source common.sh

Print_head "Setting up of MongoDB repository"
cp confiigs/mongodb.repo /etc/yum.repos.d/mongo.repo

Print_head "Install MongoDB"
yum install mongodb-org -y

Print_head "Enable MongoDB"
systemctl enable mongod

Print_head "Start MongoDB"
systemctl start mongod

#update /etc/mongodb.conf from 127.0.0.1 with 0.0.0.0
