#!/bin/bash

statuscheck(){
  if [ $1 -eq 0 ]; then
      echo -e "\e[32m SUCCESS \e[0m"
  else
      echo -e "\e[31m FAILURE \e[0m"
      exit 1
  fi
}
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
print "setup YUM repos"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>> /tmp/logfile.txt
statuscheck $?
print "install mongodb"
yum install -y mongodb-org &>> /tmp/logfile.txt
statuscheck $?
print "update mongodb listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> /tmp/logfile.txt
statuscheck $?
print "setup services"
systemctl restart mongod &>> /tmp/logfile.txt && systemctl enable mongod &>> /tmp/logfile.txt
statuscheck $?
print "Download mongodb schema files."
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>> /tmp/logfile.txt
statuscheck $?
print "Extracting Archive"
cd /tmp
unzip mongodb.zip &>> /tmp/logfile.txt
statuscheck $?
print "Load the application"
cd mongodb-main
mongo < catalogue.js &>> /tmp/logfile.txt && mongo < users.js &>> /tmp/logfile.txt
statuscheck $?



