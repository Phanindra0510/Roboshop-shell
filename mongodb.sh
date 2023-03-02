source common.sh

Print_head "Setting up of MongoDB repository"
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

Print_head "Install MongoDB"
yum install mongodb-org -y &>>${log_file}

Print_head "Update MongoDB Listen address"
sed -i -e 's/127.0.0.1/0.0.0.0' /etc/mongodb.conf &>>${log_file}

Print_head "Enable MongoDB"
systemctl enable mongod &>>${log_file}

Print_head "Start MongoDB"
systemctl restart mongod &>>${log_file}

#update /etc/mongodb.conf from 127.0.0.1 with 0.0.0.0
