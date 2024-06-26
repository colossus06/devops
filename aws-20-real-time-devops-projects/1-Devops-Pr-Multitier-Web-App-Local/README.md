# Devops-Projects


![image](https://user-images.githubusercontent.com/96833570/211034798-89b29696-0ca5-4307-9f75-623a6d307cc1.png)

* Nginx VM: web01
* tomcat vm: app01
* RabbitMQ vm: rmq01
* Memcache vm: mc01
* DB vm: db01
```
vagrant ssh web01
cat /etc/hosts
ping app01
logout
```

```
vagrant ssh app01
cat /etc/hosts
ping mc01
ping rmq01
ping db01
logout
```
# BACKEND SETUP

## 1- DB setup

```
vagrant ssh db01
sudo -i
yum update -y
echo "DATABASE_PASS='admin123'" >> /etc/profile
source /etc/profile
yum install epel-release -y
yum install git mariadb-server -y
sleep 10
systemctl start mariadb
systemctl enable mariadb
mysql_secure_installation
# Set the variable password here
mysql -u root -padmin123
# or mysql -u root -p

mysql --version

git clone -b local-setup https://github.com/devopshydclub/vprofile-project.git
cd vprofile-project
mysql -u root -p"$DATABASE_PASS" -e "create database accounts"
mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'app01' identified by 'admin123' "




mysql -u root -padmin123 accounts < src/main/resources/db_backup.sql
mysql -u root -padmin123 -e "FLUSH PRIVILEGES"
mysql -u root -p"$DATABASE_PASS"
show databases;
use accounts;
show tables;



systemctl restart mariadb




```

![image](https://user-images.githubusercontent.com/96833570/211056824-cb151598-3fcf-4e2a-a9d5-b5abc98b5b74.png)

![image](https://user-images.githubusercontent.com/96833570/211056980-a86fa573-83c9-4d77-8b82-1c8b57cc944f.png)


## 2- Memcached setup

Install, start & enable memcache on port 11211

```
vagrant ssh mc01
sudo -i
yum update -y 
yum install epel-release -y
yum install memcached -y
systemctl start memcached 
systemctl enable memcached
systemctl status memcached
memcached -p 11211 -U 11111 -u memcached -d
```

![image](https://user-images.githubusercontent.com/96833570/211066706-59508adc-54ed-42f2-9912-e7c60e65a59e.png)



## 3- RabbitMQ setup

```
vagrant ssh rmq01
cat /etc/hosts
sudo -i
yum update -y
yum install epel-release -y
yum install wget -y
cd /tmp/
wget http://packages.erlang-solutions.com/erlang-solutions-2.0-1.noarch.rpm
sudo rpm -Uvh erlang-solutions-2.0-1.noarch.rpm
sudo yum -y install erlang socat

# Install rabbitmq

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
sudo yum install rabbitmq-server -y


# Start rabbitmq
systemctl start rabbitmq-server
systemctl enable rabbitmq-server
systemctl status rabbitmq-server

Config Change
sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
rabbitmqctl add_user test admin123
rabbitmqctl set_user_tags test administrator


systemctl restart rabbitmq-server

```

# Debug

`ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)`

Solution: Add your password adjacent to the -p flag like: `-pmyuniquepass -p123456


# APP SETUP

## Tomcat Server Setup

```
vagrant ssh app01
cat /etc/hosts
sudo -i
yum update -y && yum install epel-release -y && yum install java-1.8.0-openjdk -y && yum install git maven wget -y

cd /tmp/
wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.37/bin/apache-tomcat-8.5.37.tar.gz
tar xzvf apache-tomcat-8.5.37.tar.gz

 useradd --home-dir /usr/local/tomcat8 --shell /sbin/nologin tomcat
 
cp -r /tmp/apache-tomcat-8.5.37/* /usr/local/tomcat8/ && chown -R tomcat.tomcat /usr/local/tomcat8

nano  /etc/systemd/system/tomcat.service



[Unit]
Description=Tomcat
After=network.target
[Service]
User=tomcat
WorkingDirectory=/usr/local/tomcat8
Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_HOME=/usr/local/tomcat8
Environment=CATALINE_BASE=/usr/local/tomcat8
ExecStart=/usr/local/tomcat8/bin/catalina.sh run
ExecStop=/usr/local/tomcat8/bin/shutdown.sh
SyslogIdentifier=tomcat-%i
[Install]
WantedBy=multi-user.target



systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat

```
![image](https://user-images.githubusercontent.com/96833570/211103524-acd4298e-59af-4f24-9bad-fd686f9b3995.png)



# Build and Deploy the app

On Tomcat server(app01):

```
cd /tmp/
git clone -b local-setup https://github.com/devopshydclub/vprofile-project.git

cd vprofile-project

# Update file with backend server details
src/main/resources/application.properties



# build the artifact
mvn install

# Deploy artifact
systemctl stop tomcat
sleep 120
rm -rf /usr/local/tomcat8/webapps/ROOT*
cp target/vprofile-v2.war /usr/local/tomcat8/webapps/ROOT.war
systemctl start tomcat
sleep 300
chown tomcat.tomcat /usr/local/tomcat8/webapps -R
systemctl restart tomcat


```


# Setup nginx

```
vagrant ssh web01
sudo -i
apt update -y && apt upgrade -y
apt install nginx -y
nano etc/nginx/sites-available/vproapp


upstream vproapp {
server app01:8080;
}
server {
listen 80;
location / {
proxy_pass http://vproapp;
}
}


rm -rf /etc/nginx/sites-enabled/default &&
ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp &&
systemctl restart nginx

```



![image](https://user-images.githubusercontent.com/96833570/211104213-d0438711-e593-44e4-8a75-4a1a6bca26bb.png)

![image](https://user-images.githubusercontent.com/96833570/211104951-b5721b70-0c32-40d0-bd68-a9ea99a8fa9e.png)


![image](https://user-images.githubusercontent.com/96833570/211104903-1ac63d41-2a8c-48c0-8bce-67721ba0a92e.png)


![image](https://user-images.githubusercontent.com/96833570/211108308-f3d76c04-d290-471b-aa34-9ef7ea57d666.png)

git 