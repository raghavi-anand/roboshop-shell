source common.sh

echo -e "\e[32m>>>>>>Install Nginx <<<<<<<<\e[0m"
dnf install nginx -y
func_exit_status

echo -e "\e[32m>>>>>> Creating Nginx Service <<<<<<<<\e[0m"
cp nginx-roboshop.config /etc/nginx/default.d/roboshop.conf
systemctl enable nginx
func_exit_status

echo -e "\e[32m>>>>>>Remove existing content <<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*
func_exit_status

echo -e "\e[32m>>>>>> Download application content  <<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
func_exit_status

echo -e "\e[32m>>>>>> Extract application content<<<<<<<<\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
func_exit_status

echo -e "\e[32m>>>>>> Start Nginx Service <<<<<<<<\e[0m"
systemctl enable nginx
systemctl restart nginx
func_exit_status
