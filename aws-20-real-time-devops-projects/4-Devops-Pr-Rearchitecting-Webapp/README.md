# Devops-Project-4-Refactoring-Java-Webapp-on-AWS

![image](https://user-images.githubusercontent.com/96833570/212187295-07e6a1c9-4542-455e-9202-8db147e0b560.png)


# Backend Setup

## Setup RDS client- Ubuntu 20.04

```
#!/bin/bash
sudo -i
apt update
apt install mysql-client -y

#connect to rds
mysql -h endpoint -u admin -ppsw

cd /tmp/
git clone https://github.com/devopshydclub/vprofile-project.git
cd vprofile-project
git checkout aws-Refactor
cd src/main/resources/

# initialize rds
mysql -h rds-mysql.c7rvwaqxmcfm.us-east-1.rds.amazonaws.com -u admin -ppsw accounts < db_backup.sql

# login and validate
mysql -h rds-mysql.c7rvwaqxmcfm.us-east-1.rds.amazonaws.com -u admin -ppsw accounts
show tables;
```


![](20230614094729.png)


![](20230614095009.png)

![image](https://user-images.githubusercontent.com/96833570/211896524-7b3c95d6-cefb-4553-9e48-c0b130cb4c0f.png)


After initializing the RDS i deleted the ec2 instance.

## Memcached Setup 

![image](https://user-images.githubusercontent.com/96833570/211895811-506bcfe8-ffcc-4b1a-9b61-85f223044b5b.png)

## Amazon MQ Setup


![image](https://user-images.githubusercontent.com/96833570/211899042-2351bd59-01d2-4f3a-8ac6-bcb120b2d295.png)

## Beanstalk


![image](https://user-images.githubusercontent.com/96833570/211910719-17d56fa3-c079-4d01-bfbb-f3804535bbab.png)



![](20230614131740.png)


After configuring the `/login` path, healthcheck turned from ok to severe.



![image](https://user-images.githubusercontent.com/96833570/211918514-7c61039b-6ae6-48a4-8719-f6ae883e8397.png)

## Revisiting `application.properties` / building the artifact and uploading on Beanstalk

I added the endpoints accordingly and run  `mvn install`

![image](https://user-images.githubusercontent.com/96833570/211921285-f1b5ba76-9ffa-4a6a-857a-ed8f0f47ee7f.png)



![image](https://user-images.githubusercontent.com/96833570/211925112-002b8d5b-8981-45dc-9324-080478dc0134.png)

![](20230614140502.png)



![](20230614144211.png)

## Adding cname entries pointing to the beanstalk endpoint

I updated the dns entry and waited for some time for my ISP to cache the request


![](20230614144638.png)


![](20230614144942.png)


## Validation


[pr4-validation.webm](https://github.com/colossus06/20-realtime-devops-projects/assets/96833570/ee1e84d1-5152-4141-a2b6-9ecd5dedd549)


[pr4-dnsvalidation.webm](https://github.com/colossus06/20-realtime-devops-projects/assets/96833570/b9bcf027-c9ff-408c-8f55-6bd573fb7f04)


### CDN

![](20230614151343.png)




