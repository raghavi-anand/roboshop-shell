
echo ">>>>>> Creating Catalogue Service <<<<<<<<"
cp catalogue.service /etc/systemd/system/catalogue.service

echo ">>>>>> Creating Mongo Repo <<<<<<<<"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo ">>>>>> Install NodeJS <<<<<<<<"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y

echo ">>>>>> Creating App User<<<<<<<<"
useradd roboshop

echo ">>>>>> Creating App Directory <<<<<<<<"
mkdir /app

echo ">>>>>> Download Application Content<<<<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo ">>>>>> Extract Application content <<<<<<<<"
cd /app
unzip /tmp/catalogue.zip

echo ">>>>>>Installing NodeJS dependencies <<<<<<<<"
cd /app
npm install

echo ">>>>>> Installing Mongo Client<<<<<<<<"
dnf install mongodb-org-shell -y

echo ">>>>>> Loading Schema <<<<<<<<"
mongo --host mongodb.rgdevops159.online </app/schema/catalogue.js

echo ">>>>>> Starting service <<<<<<<<"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue


