#!/bin/bash

statuscheck(){
  if [ $1 -eq 0 ]; then
      echo -e "\e[32m SUCCESS \e[0m"
  else
      echo -e "\e[31m FAILURE \e[0m"
      exit 1
  fi
}
# crate variable for user
username=roboshop
print(){
  echo -e "\e[36m $1 \e[0m"
}
USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
    echo -e "\e[31m You should run your script as sudo or root user \e[0m"
    exit 1
fi
rm -rf /tmp/logfile.txt
statuscheck $?
print "Download NodeJS"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>> /tmp/logfile.txt
statuscheck $?
print "install NodeJS"
yum install nodejs gcc-c++ -y &>> /tmp/logfile.txt
statuscheck $?
print "add User"
useradd "${username}" &>> /tmp/logfile.txt
statuscheck $?
print "Download catalogue appliaction"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>> /tmp/logfile.txt
statuscheck $?
print "Extracting archive file"
cd /home/roboshop &>> /tmp/logfile.txt && unzip /tmp/catalogue.zip &>> /tmp/logfile.txt
statuscheck $?
print "move and change the directory path and install npm"
mv catalogue-main catalogue &>> /tmp/logfile.txt  && cd /home/roboshop/catalogue &>> /tmp/logfile.txt && npm install &>> /tmp/logfile.txt
statuscheck $?
#print "Uodate syatemD cofiguration file"
#sed -i "s/"
