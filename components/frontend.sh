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
print "installing Nginx"
yum install nginx -y &>> /tmp/logfile.txt
statuscheck $?
print "Downloading Nginx content"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
statuscheck $?
print "Cleanup old nginx content"
cd /usr/share/nginx/html
rm -rf *
statuscheck $?
print "Extracting Archive"
unzip /tmp/frontend.zip && mv frontend-main/* . && mv static/* .
statuscheck $?
print "Update roboshop Configuration"
mv localhost.conf /etc/nginx/default.d/roboshop.conf
statuscheck $?
print "starting Nginx"
systemctl restart nginx && systemctl enable nginx
statuscheck $?




