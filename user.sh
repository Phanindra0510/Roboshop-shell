source common.sh

Print_head "Setup NodeJS repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

Print_head "Install NodeJS"
yum install nodejs -y &>>${log_file}
status_check $?

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
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${log_file}
cd /app &>>${log_file}
status_check $?

Print_head "Extrating Content"
unzip /tmp/user.zip &>>${log_file}
status_check $?

Print_head "Installi Dependencies"
npm install &>>${log_file}
status_check $?

Print_head "Copy System.d files"
cp ${code_dir}/configs/user.service /etc/systemd/system/user.service &>>${log_file}
status_check $?

Print_head "Reload system.d"
systemctl daemon-reload &>>${log_file}
status_check $?

Print_head "Enable user"
systemctl enable user &>>${log_file}
status_check $?

Print_head "Start user"
systemctl restart user &>>${log_file}
status_check $?

Print_head "Copy MongoDB repo"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
status_check $?

Print_head "Install MongoDB"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

Print_head "load schema"
mongo --host mongodb.ravidevops.online </app/schema/user.js &>>${log_file}
status_check $?