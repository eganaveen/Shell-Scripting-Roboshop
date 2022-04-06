#!/bin/bash

statuscheck(){
  if [ $1 -eq 0 ]; then
      echo -e "\e[32m SUCCESS \e[0m"
  else
      echo -e "\e[31m FAILURE \e[0m"
      exit 1
  fi
}
# crate variable for app_user
app_user=roboshop

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

print "add application User"
id $app_user >> /tmp/logfile.txt
if [ $? -ne 0 ]; then
    useradd ${app_user} &>> /tmp/logfile.txt
    statuscheck $?
fi


statuscheck $?
print "Download catalogue appliaction"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>> /tmp/logfile.txt
statuscheck $?
print "Cleanup old content"
rm -rf /home/${app_user}/catalogue &>> /tmp/logfile.txt
statuscheck $?
print "Extracting archive file"
cd /home/${app_user} &>> /tmp/logfile.txt && unzip -o /tmp/catalogue.zip &>> /tmp/logfile.txt
statuscheck $?
print "move and change the directory path and install npm"
mv catalogue-main catalogue &>> /tmp/logfile.txt  && cd /home/${app_user}/catalogue &>> /tmp/logfile.txt && npm install &>> /tmp/logfile.txt
statuscheck $?

print "Fix the app user permissions"
chown -R ${app_user}:${app_user} /home/${app_user}
statuscheck $?
print "Uodate syatemD cofiguration file"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.interna/' /home/roboshop/catalogue/systemd.service &>> /tmp/logfile.txt &&
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>> /tmp/logfile.txt
statuscheck $?

print "Start catalogue service"
systemctl daemon-reload &>> /tmp/logfile.txt &&
systemctl restart catalogue &>> /tmp/logfile.txt &&
systemctl enable catalogue &>> /tmp/logfile.txt
statuscheck $?
