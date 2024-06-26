#!/bin/bash
# ubuntu 20
#Change Host Name to Jenkins
sudo hostnamectl set-hostname Jenkins

#Install JDK on AWS EC2 Instance
sudo apt-get update 
sudo apt install openjdk-11-jre-headless -y
java -version

#Install and Setup Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null  

sudo apt-get update
sudo apt-get install jenkins -y

#install maven
sudo apt-get update
sudo apt install maven -y

#getting the initial psw
sudo cat /var/lib/jenkins/secrets/initialAdminPassword