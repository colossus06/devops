# Week 4 — Postgres and RDS

## Summary


This week my code was broken for 2 weeks. I could manage to overcome cors, sql issues and create activity as the last step of this week.
* Provisioned and connected to an RDS instance 
* Wrote script to update a security group rule and database operations
* Worked with UUIDs and PSQL extensions and schema sql file.
* Implement a postgres client for python using a connection pool and Lambda function that runs in a VPC and commits code to RDS
* Made cruddur button functional by creating activities.

## RDS

I started this week by debugging:

* `An error occurred (InvalidParameterValue) when calling the CreateDBInstance operation: us-east-1 is not a valid availability zone.`

I created rds instance using the following command.

```bash
aws rds create-db-instance \
  --db-instance-identifier cruddur-db-instance \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --engine-version  14.6 \
  --master-username root \
  --master-user-password huEE33z2Qvl383 \
  --allocated-storage 20 \
  --region us-east-1 \
  --availability-zone us-east-1a \
  --backup-retention-period 0 \
  --port 5432 \
  --no-multi-az \
  --db-name cruddur \
  --storage-type gp2 \
  --publicly-accessible \
  --storage-encrypted \
  --enable-performance-insights \
  --performance-insights-retention-period 7 \
  --no-deletion-protection
```

**Debugging another issue with postgres and docker**

`Is the server running on that host and accepting tcp/ip connections? connection to server at "localhost" (127.0.0.1), port 5432 failed: connection refused (0x0000274d/10061) is the server running on that host and accepting tcp/ip connections?`

I resolved this by adding `--host localhost` to my query. Also installed postgres on windows since i'm developing the app locally (yeah run out of credits🎈).

```bash
psql -Upostgres --host localhost
```

![image](https://user-images.githubusercontent.com/96833570/224510346-51b81fc8-6076-4104-9a0f-bd9f97bfd152.png)

![image](https://user-images.githubusercontent.com/96833570/224562141-b17a3ac9-c71c-41ec-959a-d44864bceda8.png)


## db-drop

I encountered another error and debugged error as shown:

* `ERROR:  database "cruddur" is being accessed by other users DETAIL:  There are 4 other sessions using the database.` 

```sql
select * from pg_stat_activity;
select pg_terminate_backend(pid) 
from pg_stat_activity
where pid = '50';
```

Or you can delete all sessions other than yours:

```sql
SELECT pid, pg_terminate_backend(pid) 
FROM pg_stat_activity 
WHERE datname = current_database() AND pid <> pg_backend_pid();
```

Now i could run db-setup script🎉:


### Security group

Now it's time to update sg dynamically. First i used the following env to set them, and then replaced with local ones.

```bash
export GITPOD_IP=$(curl icanhazip.com)
gp env GITPOD_IP=$(curl icanhazip.com)
```
I needed to export some othen vars such as security group id and rule.

```bash
export DB_SG_ID="sg-0b4c0bdc8b9f2110d" \
gp env DB_SG_ID="sg-0b4c0bdc8b9f2110d" \
export DB_SG_RULE_ID="sgr-0076bdf38773d6838" \
gp env DB_SG_RULE_ID="sgr-0076bdf38773d6838"
```
I got another error and debugged it by specifying region:

`CIDR block /32 is malformed`

```bash
aws ec2 modify-security-group-rules \
    --group-id $DB_SG_ID \
    --region $AWS_DEFAULT_REGION \
    --security-group-rules "SecurityGroupRuleId=$DB_SG_RULE_ID,SecurityGroupRule={Description=devcontainer,IpProtocol=tcp,FromPort=5432,ToPort=5432,CidrIpv4=$GITPOD_IP/32}"
```

**update on dev environment**

Since i  reached the usage limit on Gitpod, i setup a local dev environment with devcontainers and could succesfully provision RDS Instance/ Connect to RDS via devcontainers.

![image](https://user-images.githubusercontent.com/96833570/224793344-46a20fc6-8722-41cd-8f4b-40cb015a5961.png)

![image](https://user-images.githubusercontent.com/96833570/224793423-47dc8bec-7db4-4b8e-849e-ccd139b66374.png)

**another update on dev environment**

I moved on totally local dev environment and did all the steps for the third time.


### SQL

I operated common SQL commands and created scripts working locally on windows to
* drop
* create
* connect the database cruddur.

Also created a connection url string to ease db related workload, changed print colors to enhance shell script readability. My db-setup script is as shown:

```sh
source "$file_path/bin/db-drop"
source "$file_path/bin/db-create"
source "$file_path/bin/db-schema-load"
source "$file_path/bin/db-seed"
```

You can see all the tables running the following after connecting to your database:

```bash
SELECT * FROM activities;
```

## sql rds connection pooling
I added `psycopg[binary]` and `psycopg[pool]` since i wanted to let my database handle multiple concurrent connections. Then i could use one reusable connection pool.

## Week 4- Cognito Post Confirmation Lambda

* I created a lambda and role for cruddur post confirmation. 
* Added another layer to my lambda.
* Added lambda trigger in cognito for post confirmation during user signup. 
* Connected my lambda to a vpc and crea
* Deleted my users to trigger the cloudwatch.


Error: `AWS Lambda:The provided execution role does not have permissions to call DescribeNetworkInterfaces on EC2`

Solution: I created and attached the following inline policy to deploy a Lambda into a VPC

```aws
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeNetworkInterfaces",
        "ec2:CreateNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeInstances",
        "ec2:AttachNetworkInterface"
      ],
      "Resource": "*"
    }
  ]
}
```
## Displaying prod users

I ran db.setup script with `prod` argument. Connected to it with  the following command:

```bash
psql $PROD_CONNECTION_URL
```

And displayed all my users:

```sql
select * from users;
```


![image](https://user-images.githubusercontent.com/96833570/226624094-c7e1a845-d91b-4f89-8870-6a5de8c5338d.png)

## Creating Activities

I worked log time to debug `No 'Access-Control-Allow-Origin' header is present on the requested resource. If an opaque response serves your needs, set the request's mode to 'no-cors' to fetch the resource with CORS disabled.` I could create activity for my user with the help of flask-cors documentation on localhost.

![image](https://user-images.githubusercontent.com/96833570/229313459-f075a798-ee00-4352-9b6b-7dc26799e6b5.png)


![image](https://user-images.githubusercontent.com/96833570/229313551-b0e92032-c2cc-4d2f-b0a7-78b2667b1e77.png)


