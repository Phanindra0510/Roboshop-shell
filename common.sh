code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

Print_head(){
  echo -e "\e[36m$1\e[om"
}

status_check (){
  if [ $1 -eq 0 ]
  then
    echo SUCCESS
  else
    echo FAILURE
    echo "Read the log file ${log_file} for more information about error"
    exit 1
  fi
}