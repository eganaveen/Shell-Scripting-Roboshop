#!/bin/bash

statuscheck(){
  if [ $1 -eq 0 ]; then
      echo -e "\e[32m SUCCESS \e[0m"
  else
      echo -e "\e[31m FAILURE \e[0m"
      exit 1
  fi
}
USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
    echo -e "\e[31m You should run your script as sudo or root user \e[0m"
    exit 1
fi
echo -e "\e[36m installing Nginx \e[0m"
yum install nginx -y
statuscheck $?
echo -e "\e[36m Downloading Nginx content \e[0m"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zi"
statuscheck $?
echo -e "\e[36m Cleanup old nginx content and Extract new download archive file and load confiuration file \e[0m"
cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
statuscheck $?
echo -e "\e[36m starting Nginx \e[0m"
systemctl restart nginx
statuscheck $?
systemctl enable nginx


