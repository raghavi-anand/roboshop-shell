log = /tmp/roboshop.log

echo -e "\e[32m>>>>>> Creating Catalogue Service <<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service &>>log

echo -e "\e[32m>>>>>> Creating Mongo Repo <<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>log

echo -e "\e[32m>>>>>> Install NodeJS <<<<<<<<\e[0m"
dnf module disable nodejs -y &>>log
dnf module enable nodejs:18 -y &>>log
dnf install nodejs -y &>>log

echo -e "\e[32m>>>>>> Creating App User<<<<<<<<\e[0m"
useradd roboshop &>>log

echo -e "\e[32m>>>>>> Removing existing App Directory <<<<<<<<\e[0m"
rm -rf /app &>>log

echo -e "\e[32m>>>>>> Creating App Directory <<<<<<<<\e[0m"
mkdir /app &>>log

echo -e "\e[32m>>>>>> Download Application Content<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>log

echo -e "\e[32m>>>>>> Extract Application content <<<<<<<<\e[0m"
cd /app &>>log
unzip /tmp/catalogue.zip &>>log

echo -e "\e[32m>>>>>>Installing NodeJS dependencies <<<<<<<<\e[0m"
cd /app &>>log
npm install &>>log

echo -e "\e[32m>>>>>> Installing Mongo Client<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y &>>log

echo -e "\e[32m>>>>>> Loading Schema <<<<<<<<\e[0m"
mongo --host mongodb.rgdevops159.online </app/schema/catalogue.js &>>log

echo -e "\e[32m>>>>>> Starting service <<<<<<<<\e[0m"
systemctl daemon-reload &>>log
systemctl enable catalogue &>>log
systemctl restart catalogue &>>log


