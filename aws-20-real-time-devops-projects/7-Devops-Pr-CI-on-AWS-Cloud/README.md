## Continious Integration on AWS Cloud


![](20230615113159.png)


### Code Commit

```sh
ssh git-codecommit.us-east-1.amazonaws.com
git clone https://github.com/devopshydclub/vprofile-project.git


cat .git/config

git branch -a | grep -v HEAD | cut -d "/" -f3 | grep -v master
for i in `cat branches.txt`;do echo $i;done
for i in `cat branches.txt`;do git checkout $i;done 

git remote rm origin
git remote add origin ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/repo-name

```


![](20230614160901.png)


![](20230614160952.png)


![](20230614164212.png)




## Code Build


![](20230615024811.png)

Sonar scanning analysis report:

![](20230615024516.png)



## CI Validation


Aws cloud based CI solutions:

![](20230615113430.png)


![](20230615113444.png)


![](20230615113548.png)