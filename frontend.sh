source common.sh

Print_head "Installing nginx"
yum install nginx -y &>>${log_file}
status_check $?

Print_head "Removing old content nginx"
rm -rf /usr/share/nginx/html/* &>>${log_file}
status_check $?

Print_head "Downloading nginx"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
status_check $?

Print_head "Extracting file nginx"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}
status_check $?

Print_head "Copying configs of nginx for roboshop"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
status_check $?

Print_head "Enabling nginx"
systemctl enable nginx &>>${log_file}
status_check $?

Print_head "Starting nginx"
systemctl restart nginx &>>${log_file}
status_check $?
