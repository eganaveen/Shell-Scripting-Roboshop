#!/bin/bash
USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
    echo You should run your script as sudo or root user
    exit 1
fi
echo -e "\e[36m installing Nginx \e[0m"
yum install nginx -y
echo -e "\e[36m Downloading Nginx content \e[0m"
curl  -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zp"
echo -e "\e[36m Cleanup old nginx content and Extract new download archive file and load confiuration file \e[0m"
cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[36m starting Nginx \e[0m"
systemctl enable nginx
systemctl restart nginx


