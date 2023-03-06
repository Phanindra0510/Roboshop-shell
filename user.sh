source common.sh

Print_head "Downloading NodeJS"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

Print_head "Install Nodejs"
yum install nodejs -y &>>${log_file}
status_check $?

Print_head "Adding user"
if [ $? -ne 0 ]; then
 useradd roboshop &>>${log_file}
fi
status_check $?

Print_head "Creating Directory"
if [ ! -d /app ]; then
 mkdir /app &>>${log_file}
fi
status_check $?

Print_head "Remove old content"
rm -rf /app/* &>>${log_file}
status_check $?

Print_head "Downloading Catalogue Content"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${log_file}
cd /app &>>${log_file}
status_check $?

Print_head "Extracting content"
unzip /tmp/user.zip &>>${log_file}
status_check $?

Print_head "NodeJS Dependencies"
npm install &>>${log_file}
status_check $?

Print_head "Copy system.d files"
cp ${code_dir}/configs/user.service /etc/systemd/system/user.service &>>${log_file}
status_check $?

Print_head "Reload system.d"
systemctl daemon-reload &>>${log_file}
status_check $?

Print_head "Enable User"
systemctl enable user &>>${log_file}
status_check $?

Print_head "Start User"
systemctl restart user &>>${log_file}
status_check $?

# To load schema
Print_head "Copy MongoDB repo"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
status_check $?

Print_head "Install MongoDB"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

Print_head "load schema"
mongo --host mongodb.ravidevops.online </app/schema/user.js &>>${log_file}
status_check $?