source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" == "mysql" ]
 then
   echo -e "\e[31mMissing MySQL Root Password\e[0m"
   exit 1
fi

component=shipping
schema_type="mysql"
java