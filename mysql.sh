mysql_password=$1

if [ -z "${mysql_password}" ]; then
  echo Input password missing
  exit 1
fi

cp mysql.repo /etc/yum.repos.d/mysql.repo

dnf module disable mysql -y

dnf install mysql-community-server -y

systemctl enable mysqld
systemctl start mysqld

mysql_secure_installation --set-root-pass ${mysql_password}

