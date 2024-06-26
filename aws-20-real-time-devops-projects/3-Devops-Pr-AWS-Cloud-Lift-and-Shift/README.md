# Devops-Projects-3-AWS-Lift-and-Shift




![image](https://user-images.githubusercontent.com/96833570/211544752-3a0a22db-c310-42ec-8e87-a627181fdc04.png)




## BACKEND STACK SETUP


![image](https://user-images.githubusercontent.com/96833570/211214592-65776762-545c-47de-a8b9-b8a505beacc1.png)


## SG backend

![](20230613092855.png)


### Db Setup - 3306

```sh
ssh -i ../../Downloads/vprofile-kp.pem centos@13.48.194.215
sudo -i
```
### displaying user-data script

`cat /var/lib/cloud/instances/${instance-id}/user-data.txt`


`systemctl status mariadb`

![](20230613095535.png)

![](20230613095740.png)

### Memcached setup - 11211


```
systemctl status memcached
ssh -i ../../Downloads/vprofile-kp.pem centos@16.171.1.184
curl http://169.254.169.254/latest/user-data
ss -tunlp | grep 11211
```

![image](https://user-images.githubusercontent.com/96833570/211188094-a2d20862-bccd-4cbc-8474-a24102662e10.png)

![image](https://user-images.githubusercontent.com/96833570/211188244-843bc717-798e-47ce-880f-7bf39abe696a.png)

### Rabbitmq setup - 5672

![image](https://user-images.githubusercontent.com/96833570/211188312-82b811fa-29fe-4193-a2f4-32901962249c.png)

![image](https://user-images.githubusercontent.com/96833570/211188323-322c5571-5bce-4db1-9614-c320e61c2c06.png)


## Updating private ip addresses of the servers in Route53

![image](https://user-images.githubusercontent.com/96833570/211204890-a88a7525-db8c-4316-b738-2015a42642d8.png)


![image](https://user-images.githubusercontent.com/96833570/211213304-22002b86-19b1-4465-a076-13f6f167ade8.png)


## Building the artifact locally

Now build the artifact locally and store it in S3 bucket. Then we will download this to our tomcat app server.


`choco install jdk8`

`choco install maven -y`

`choco install awscli -y`

### Configuring aws cli/iam user with full s3 access


![image](https://user-images.githubusercontent.com/96833570/211206531-684484ef-914e-4329-b903-4f8683c4a961.png)


`mvn install`


Let's create a bucket and copy our artifact:

```
aws s3 mb s3://devops-projects-artifact-st
aws s3 cp vprofile-v2.war s3://vprofile-artifact-storage-devops/vprofile-v2.war

```

### Creating and attaching an IAM role for tomcat app service

We want to able to download the war file on our app server. 


![image](https://user-images.githubusercontent.com/96833570/211214669-bb1022bf-2d21-4192-8180-2a06ad478a76.png)

![image](https://user-images.githubusercontent.com/96833570/211214687-53e13359-36a6-4bea-9d74-ee668b3677e3.png)

## Setup App Server

`curl http://169.254.169.254/latest/user-data`

![image](https://user-images.githubusercontent.com/96833570/211541247-ac0a48b5-c85a-4aa1-a338-386fa545425b.png)

![image](https://user-images.githubusercontent.com/96833570/211541319-f8ab2e42-12b6-492f-a9d0-fd88fe369a3e.png)


We need to delete default app on tomcat8 and download our war file from s3.

![image](https://user-images.githubusercontent.com/96833570/211214822-adc3793b-1bf5-439c-a95a-a0e7981ef7e8.png)

```
sudo -i
apt install awscli -y
systemctl stop tomcat
cd /var/lib/tomcat8/webapps/
rm -rf ROOT
aws s3 ls
aws s3 mb s3://vprofile-artifact-storage-devops
aws s3 cp ./target/vprofile-v2.war s3://vprofile-artifact-storage-devops/vprofile-v2.war

aws s3 cp s3://vprofile-artifact-storage-devops/vprofile-v2.war /tmp/vprofile-v2.war

sudo -i
systemctl stop tomcat9
cd /var/lib/tomcat9/webapps
rm -rf ROOT


cp /tmp/vprofile-v2.war ./ROOT.war
systemctl start tomcat9

cd ROOT
cd /var/lib/tomcat9/webapps/ROOT/WEB-INF/classes
cat application.properties
telnet db01.devops.devtechops.dev 3306

telnet rmq01.devops.devtechops.dev 5672
telnet mq01.devops.devtechops.dev 11211

```

We can check db connection via telnet:



![](20230613170115.png)


<hr>

## Setup load balancer and target groups

![image](https://user-images.githubusercontent.com/96833570/211546007-e20a6c56-4d28-4644-86ca-cf83908e3acd.png)


## Auto-scaling and launch templates

![](20230613200117.png)

![](20230613203456.png)

![](20230613203750.png)

![](20230613204947.png)


## Validation


[pr3-validation.webm](https://github.com/colossus06/20-realtime-devops-projects/assets/96833570/00ec5bdf-4704-483e-925d-21823b535829)





![](20230613205644.png)