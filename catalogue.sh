source common.sh

Print_head "Downloading NodeJS"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

Print_head "Install Nodejs"
yum install nodejs -y &>>${log_file}

Print_head "Adding user"
useradd roboshop &>>${log_file}

Print_head "Creating Directory"
mkdir /app &>>${log_file}

Print_head "Remove old content"
rm -rf /app/* &>>${log_file}

Print_head "Downloading Catalogue Content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
cd /app &>>${log_file}

Print_head "Extracting content"
unzip /tmp/catalogue.zip &>>${log_file}

Print_head "NodeJS Dependencies"
npm install &>>${log_file}

Print_head "Copy system.d files"
cp configs/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}

Print_head "Reload system.d"
systemctl daemon-reload &>>${log_file}

Print_head "Enable catalogue"
systemctl enable catalogue &>>${log_file}

Print_head "Start catalogue"
systemctl restart catalogue &>>${log_file}

# To load schema
Print_head "Copy MongoDB repo"
cp configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}

Print_head "Install MongoDB"
yum install mongodb-org-shell -y &>>${log_file}

Print_head "load schema"
mongo --host mongodb.ravidevops.online </app/schema/catalogue.js &>>${log_file}