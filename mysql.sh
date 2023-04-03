source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" ]
 then
   echo-e "\e[31mMissing MySQL Root Password\e[0m"
   exit1
fi

Print_head "Disable MySQL 8 Version"
dnf module disable mysql -y &>>${log_file}
status_check $?

Print_head "Copying MySQL repo"
cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
status_check $?

Print_head "Install MySQL server"
yum install mysql-community-server -y &>>${log_file}
status_check $?

Print_head "Enable MySQL Service"
systemctl enable mysqld &>>${log_file}
status_check $?

Print_head "Start MySQL Service"
systemctl start mysqld &>>${log_file}
status_check $?

Print_head "Set Root Password"
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}
status_check $?