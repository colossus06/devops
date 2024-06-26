# Week 5 — DynamoDB and Serverless Caching

## Summary

This week:

* Worked with Dynamodb local and prod one table cruddur-messages.
* Implemented Pattern Scripts for crud operations of conversations. 
* Setup DynamoDB stream trigger to update message groups.
* Created a Python lambda function and logged the events with CloudWatch.

### Environment

* Windows 10 -wsl
* Local

Started this week running the app locally, installing postgress and changing the default user in environment variables to `postgres`.

Verified that dynamodb is running and created my first table:


![bad interpreter fix](images/20230402172556.png)

Dealt with `M: bad interpreter: No such file or directory"`issue and could solve it with the following command:

```bash
sed -i -e 's/\r$//' list-tables.sh
./list-tables.sh
```
Note: *The first line of my `schema-load` running python script was `#!/usr/bin/python`.*

![tables](images/20230402172716.png)

Now I could change my `.py` files to `.sh`. Now i had only one table.

```bash
aws dynamodb delete-table --endpoint-url=http://localhost:8000\
    --table-name Music
    --output table
```

![table](images/20230402173454.png)


** steps to reproduce this**

```bash
./setup.sh 
cd ../ddb/
./drop.sh cruddur-messages
./schema-load.sh 
./list-tables.sh
./seed.sh
```


![seed](images/20230402200212.png)


List cognito users :

```bash
aws cognito-idp list-users --user-pool-id congito-pool-id --limit 5
```

## Implement dynamodb into backend


I am so happy to implement conversations. I had to debug various errors before getting messages on UI. Such as the following:

* `NoCredentialsError: Unable to locate credentials boto3`
* `python OSError: [Errno 12] Cannot allocate memory:`


![](images/20230403190511.png)

To solve the above errors added 3G to swap and use dotenv for my environment secrets. I was able to create direct messages now.

![](images/20230404091947.png)

## Setup DynamoDB Stream

I created a ddb table and vpc endpoint for dynamodb:



```bash
./schema-load prod
```


![](images/20230404092728.png)


Created a lambda function and attached `AWSLambdaInvocation-DynamoDB` and `AmazonDynamoDBFullAccess` permissions for my lambda to invoke ddb.

Then commented out the local ddb url and run docker-compose down and up. I tried to create a message using `/messages/new/londo`



![](images/20230404105921.png)

![](images/20230404105941.png)

Here are my items returned:

![](images/20230404110731.png)

I think I've learned a lot. Happy to finish this week🙋‍♂️!