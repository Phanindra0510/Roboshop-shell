source common.sh

roboshop_app_password=$1
if [ -z "${roboshop_app_password}" ]
 then
   echo -e "\e[31mMissing Roboshop App Password\e[0m"
   exit 1
fi

Print_head "Setup of Erlang"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log_file}
status_check $?

Print_head "Install Erlang"
yum install erlang -y &>>${log_file}
status_check $?

Print_head "Setup of RabbitMQ"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log_file}
status_check $?

Print_head "Install RabbitMQ"
yum install rabbitmq-server -y &>>${log_file}
status_check $?

Print_head "Enable RabbitMQ"
systemctl enable rabbitmq-server &>>${log_file}
status_check $?

Print_head "Start RabbitMQ"
systemctl start rabbitmq-server &>>${log_file}
status_check $?

Print_head "Add App User"
sudo rabbitmqctl list_users|grep roboshop &>>${log_file}
if [ $? -ne 0 ]; then
 rabbitmqctl add_user roboshop ${roboshop_app_password} &>>${log_file}
fi
status_check $?

Print_head "Set App Permission"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
status_check $?