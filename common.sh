code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

Print_head() {
  echo -e "\e[36m$1\e[om"
}

status_check () {
  if [ $1 -eq 0 ]
  then
    echo SUCCESS
  else
    echo FAILURE
    echo "Read the log file ${log_file} for more information about error"
    exit 1
  fi
}

systemd_setup () {

   Print_head "Copy System.d files"
    cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
    status_check $?

    Print_head "Reload system.d"
    systemctl daemon-reload &>>${log_file}
    status_check $?

    Print_head "Enable ${component}"
    systemctl enable ${component} &>>${log_file}
    status_check $?

    Print_head "Start ${component}"
    systemctl restart ${component} &>>${log_file}
    status_check $?
}

schema_setup () {
  if [ "${schema_type}" == "mongo" ];
  then
    Print_head "Copy MongoDB repo"
    cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
    status_check $?

    Print_head "Install MongoDB"
    yum install mongodb-org-shell -y &>>${log_file}
    status_check $?

    Print_head "load schema"
    mongo --host mongodb.ravidevops.online </app/schema/${component}.js &>>${log_file}
    status_check $?
  elif [ "${schema_type}" == "mysql" ]; then
    Print_head "Install MySQL Client"
    yum install mysql -y &>>${log_file}
    status_check $?

    Print_head "Load Schema"
    mysql -h mysql.ravidevops.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql
    status_check $?
  fi
}

app_prereq_setup() {
   Print_head "Creating Roboshop user"
   id roboshop &>>${log_file}
   if [ $? -ne 0 ]; then
    useradd roboshop &>>${log_file}
   fi
   status_check $?

   Print_head "Creating Application Directory"
   if [ ! -d /app ]; then
    mkdir /app &>>${log_file}
   fi
   status_check $?

   Print_head "Removing Old Content"
   rm -rf /app/* &>>${log_file}
   status_check $?

   Print_head "Downloading Application Code"
   curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
   cd /app &>>${log_file}
   status_check $?

   Print_head "Extrating Content"
   unzip /tmp/${component}.zip &>>${log_file}
   status_check $?
}

nodejs() {
  Print_head "Setup NodeJS repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
  status_check $?

  Print_head "Install NodeJS"
  yum install nodejs -y &>>${log_file}
  status_check $?

  app_prereq_setup

  Print_head "Installing Dependencies"
  npm install &>>${log_file}
  status_check $?

  schema_setup

  systemd_setup

}

java() {

  Print_head "Install Maven"
  yum install maven -y &>>${log_file}
  status_check $?

  app_prereq_setup

  Print_head "Download Dependencies & Package"
  mvn clean package &>>${log_file}
  mv target/${component}-1.0.jar ${component}.jar &>>${log_file}
  status_check $?

  schema_setup

  systemd_setup
}