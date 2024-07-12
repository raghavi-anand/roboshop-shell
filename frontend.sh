source common.sh

echo -e "\e[32m>>>>>>Install Nginx <<<<<<<<\e[0m"
dnf install nginx -y &>>$log
func_exit_status

echo -e "\e[32m>>>>>> Creating Nginx Service <<<<<<<<\e[0m"
cp nginx-roboshop.config /etc/nginx/default.d/roboshop.conf &>>$log
systemctl enable nginx &>>$log
func_exit_status

echo -e "\e[32m>>>>>>Remove existing content <<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/* &>>$log
func_exit_status

echo -e "\e[32m>>>>>> Download application content  <<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log
func_exit_status

echo -e "\e[32m>>>>>> Extract application content<<<<<<<<\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$log
func_exit_status

echo -e "\e[32m>>>>>> Start Nginx Service <<<<<<<<\e[0m"
systemctl enable nginx &>>$log
systemctl restart nginx &>>$log
func_exit_status
