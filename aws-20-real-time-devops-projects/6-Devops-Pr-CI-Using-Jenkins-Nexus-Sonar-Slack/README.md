# Continuous Integration Using Jenkins, Nexus, Sonarqube & slack


![](20230617012759.png)

![image](https://github.com/colossus06/20-realtime-devops-projects/assets/96833570/c29cdce4-3612-414a-b68c-bd2f20156480)


Install tools:

* maven integration
* github integration
* Nexus Artifact Uploader
* SonarQube ScannerVersion
* Slack Notification
* Build Timestamp


```sh
tail -f /opt/nexus/sonatype-work/nexus3/log/nexus.log
```

## git code migration

```sh
ssh -T git@github.com
git remote set-url origin git@github.com:your-ssh-repo-url
git branch -c ci-jenkins
git checkout ci-jenkins
git push --all origin
```


![](20230616121546.png)

maven-proxy repo: `https://repo1.maven.org/maven2/`

![](20230616170728.png)


Grouping the maven repositories:

![](20230616171210.png)

## Build job with nexus repo

```sh
sudo -i
su - jenkins
git ls-remote -h git@github.com:colossus06/vpro-ci-project.git HEAD
```

fixing illegar character:

![](20230616183149.png)


![](20230616183217.png)


![](20230616183536.png)

## Github Webhook

Add a webhook in github settings:

`http://3.83.88.201:8080/github-webhook/`


![](20230616183925.png)

#### GitHub hook trigger for GITScm polling and Github Webhook

![](20230616184023.png)

![](20230616191222.png)




##  Code Analysis with Sonarqube

![](20230616235235.png)

### Quality Gates and webhook

![](20230616235517.png)


![](20230617000008.png)

![](20230617000059.png)

![](20230617000207.png)

## Publish artifact to nexus repo

![](20230617002308.png)

![](20230617002359.png)


## Validation

[pr6-validation.webm](https://github.com/colossus06/20-realtime-devops-projects/assets/96833570/5fc56603-81bb-4fd3-90e5-d6a0ab6af0fc)
