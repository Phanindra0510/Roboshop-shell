code_dir=$(pwd)
log_files=/tmp/roboshop.log
rm -f ${log_file}

Print_head(){
  ech0 -e "\e[36$1\e[om"
}
Print_head "Installing nginx"
yum install nginx -y &2>${log_file}

Print_head "Removing old content nginx"
rm -rf /usr/share/nginx/html/* &2>${log_file}

Print_head "Downloading nginx"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &2>${log_file}

Print_head "Extracting file nginx"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &2>${log_file}

Print_head"Copying configs of nginx for roboshop"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &2>${log_file}

Print_head "Enabling nginx"
systemctl enable nginx &2>${log_file}

Print_head "Starting nginx"
systemctl restart nginx &2>${log_file}
