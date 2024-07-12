log=/tmp/roboshop.log

func_apppreq(){
  echo -e "\e[32m>>>>>> Creating ${component} Service <<<<<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>$log

  echo -e "\e[32m>>>>>> Creating App User<<<<<<<<\e[0m"
  useradd roboshop &>>$log

  echo -e "\e[32m>>>>>> Removing existing App Directory <<<<<<<<\e[0m"
  rm -rf /app &>>$log

  echo -e "\e[32m>>>>>> Creating App Directory <<<<<<<<\e[0m"
  mkdir /app &>>$log

  echo -e "\e[32m>>>>>> Download Application Content<<<<<<<<\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log

  echo -e "\e[32m>>>>>> Extract Application content <<<<<<<<\e[0m"
  cd /app &>>$log
  unzip /tmp/${component}.zip &>>$log

}

func_systemd(){
  echo -e "\e[32m>>>>>> Starting ${component} service <<<<<<<<\e[0m"
  systemctl daemon-reload &>>$log
  systemctl enable ${component} &>>$log
  systemctl restart ${component} &>>$log
}

func_schema_setup(){
  if [ "${schema_type}" == "mongodb" ]; then
    echo -e "\e[32m>>>>>> Installing Mongo Client<<<<<<<<\e[0m"
    dnf install mongodb-org-shell -y &>>$log

    echo -e "\e[32m>>>>>> Loading Schema <<<<<<<<\e[0m"
    mongo --host mongodb.rgdevops159.online </app/schema/${component}.js &>>$log
  fi

  if [ "${schema_type}" == "mysql" ]; then
    echo -e "\e[32m>>>>>> Install mysql client <<<<<<<<\e[0m"
      dnf install mysql -y &>>$log

      echo -e "\e[32m>>>>>> Load Schema<<<<<<<<\e[0m"
      mysql -h mysql.rgdevops159.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>$log
  fi
}

func_nodejs(){


echo -e "\e[32m>>>>>> Creating Mongo Repo <<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$log

echo -e "\e[32m>>>>>> Install NodeJS <<<<<<<<\e[0m"
dnf module disable nodejs -y &>>$log
dnf module enable nodejs:18 -y &>>$log
dnf install nodejs -y &>>$log

func_apppreq

echo -e "\e[32m>>>>>>Installing NodeJS dependencies <<<<<<<<\e[0m"
cd /app &>>$log
npm install &>>$log

func_schema_setup

func_systemd

}

func_java(){

  echo -e "\e[32m>>>>>> Install Maven <<<<<<<<\e[0m"
  dnf install maven -y &>>$log

  func_apppreq

  echo -e "\e[32m>>>>>> Build shipping Service <<<<<<<<\e[0m"
  cd /app &>>$log
  mvn clean package &>>$log
  mv target/shipping-1.0.jar shipping.jar &>>$log

  func_schema_setup

  func_systemd
}

func_python(){

  echo -e "\e[32m>>>>>>Install python<<<<<<<<\e[0m"
  dnf install python36 gcc python3-devel -y &>>$log

  func_apppreq

  echo -e "\e[32m>>>>>> Install Python dependencies <<<<<<<<\e[0m"
  cd /app
  pip3.6 install -r requirements.txt &>>$log

  func_systemd
}