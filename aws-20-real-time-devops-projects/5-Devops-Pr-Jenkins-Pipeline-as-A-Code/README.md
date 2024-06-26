# Continuous Integration Using Jenkins, Nexus, Sonarqube & slack

Before creating a job:

make sure there is 
* jdk8: OracleJDK8 JAVA_HOME: /usr/lib/jvm/java-1.8.0-openjdk-amd64
* and maven: MAVEN3

```sh
sudo apt install openjdk-8-jdk -y
sudo -i
ls /usr/lib/jvm
/usr/lib/jvm/java-1.8.0-openjdk-amd64
```


![](20230615122506.png)


## Sample Pipeline

Tools:

* Pipeline Utility Steps
* pipeline maven integration


![](20230615223008.png)

![](20230615223216.png)