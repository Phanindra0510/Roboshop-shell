code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

Print_head(){
  echo -e "\e[35m$1\e[om"
}

status_check (){
  if [ $? == 0 ]
  then
    echo SUCCESS
  else
    echo FAILURE
  exit 1
  fi
}