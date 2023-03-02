code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

Print_head(){
  echo -e "\e[35m$1\e[om"
}
