ssh -i "your-key.pem" ubuntu@your-ec2-public-ip
# Update system
sudo apt update -y

# Install Apache and PHP
sudo apt install apache2 php libapache2-mod-php -y
sudo systemctl enable apache2
sudo systemctl start apache2

# Install MySQL with weak credentials
sudo apt install mysql-server -y
sudo systemctl enable mysql
sudo systemctl start mysql

# Create an intentionally weak MySQL user
sudo mysql -e "CREATE USER 'admin'@'%' IDENTIFIED BY 'password123';"
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;"

# Allow MySQL remote connections (EXPOSED DATABASE)
sudo sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql

# Deploy a vulnerable PHP web application
echo '<?php phpinfo(); ?>' | sudo tee /var/www/html/info.php
sudo systemctl restart apache2
