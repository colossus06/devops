# Week 0 — Billing and Architecture



### Summary: 

This week I worked on the following:

Aws cli, budget, meter-billing:
* I installed and configured aws cli using gitpod.yml
* Calculated the monthly/yearly budget of t2.micro
* Created a budget, sns topic and alarm on via UI and CLI

Architectural design, EventBridge:
* Recreated the logical diagram of cruddur on lucid.app
* I created an sns topic and enabled email subscription to track service health issue using EventBridge.


## Required Homework/Tasks

### Install and Verify AWS CLI

I created `.gitpod.yml` file and configured to persist aws cli and restarted the gitpod

![image](https://user-images.githubusercontent.com/96833570/220199484-771bfa59-86a8-4e80-b71c-cea8b8d3c2e2.png))


### Generate AWS Credentials

I created an IAM admin and configured the credentials.

![image](https://user-images.githubusercontent.com/96833570/220199856-266ff98f-79f4-4a17-bf57-2442ca007c68.png)






### Create a Budget

## Calculating the monthly budget

![image](https://user-images.githubusercontent.com/96833570/220199254-ba133c68-a3a4-4ad2-bd7f-980a5fb2f78b.png)


#### UI

![image](https://user-images.githubusercontent.com/96833570/220195204-bd6a0de0-d5d4-43e0-acf8-dfe82055064a.png)


#### CLI

I excercised creating another one and but with cli this time using [official documentation](https://docs.aws.amazon.com/cli/latest/reference/budgets/create-budget.html) and [week 0 video](https://www.youtube.com/watch?v=OdUnNuKylHg&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=16&ab_channel=ExamPro).


I created the following files in `aws/json` dir:
* alarm-config.json
* budget.json
* notifications-with-subscribers.json

**creating a budget**

```
aws budgets create-budget \
    --account-id $ACCOUNT_ID \
    --budget file://aws/json/budget.json \
    --notifications-with-subscribers file://aws/json/notifications-with-subscribers.json
```

![image](https://user-images.githubusercontent.com/96833570/220205470-48942682-ef9b-4aa3-a78f-005575db9340.png)

**Creating sns topic**

```
aws sns subscribe \
    --topic-arn="arn:aws:sns:us-east-1:782114400256:billing-alarm-cli" \
    --protocol=email \
    --notification-endpoint=topcug@devtechops.dev
 ```

![image](https://user-images.githubusercontent.com/96833570/220206808-f16100dd-f20c-424c-b6f7-8328fd1bff57.png)


Confirmed the subscription

![image](https://user-images.githubusercontent.com/96833570/220206794-478afc7b-b86c-4fe0-a86c-ff3532aac18f.png)


**creating an alarm**

`aws cloudwatch put-metric-alarm --cli-input-json file://aws/json/alarm-config.json`

![image](https://user-images.githubusercontent.com/96833570/220207777-fe343926-1ff6-44d5-9282-b272fd568efe.png)


### Create an architectural diagram the CI/CD logical pipeline in Lucid Charts


![image](https://user-images.githubusercontent.com/96833570/220344938-96d760a7-3311-4b75-81cf-c8bf0974926c.png)


[Lucid Charts Share Link](https://lucid.app/lucidchart/61c14870-6ad9-486e-868a-04f85b5bc501/edit?viewport_loc=-1196%2C43%2C2994%2C1437%2C0_0&invitationId=inv_8ec00958-a2e7-4f8c-b61a-f9384f082d8b)

### Use EventBridge to hookup Health Dashboard to SNS and send notification when there is a service health issue

I created an sns topic and enabled email subscription on this topic. After confirming subscription, created an event bridge rule to track/monitor AWS Health events.

![image](https://user-images.githubusercontent.com/96833570/220341439-7e5f7ebe-7739-4723-affb-9e1045b8eb80.png)

![image](https://user-images.githubusercontent.com/96833570/220342238-7a066082-23c3-44e7-9c79-563aa2e7d583.png)


```
{
  "source": ["aws.health"],
  "detail-type": ["AWS Health Event"]
}
```

![image](https://user-images.githubusercontent.com/96833570/220342924-3c8e15ec-6824-4dc8-80e6-69b26ad50126.png)


___

___

#### Takeaways

```
aws sts get-caller-identity

aws sts get-caller-identity --query Account --output text

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

env | grep ACCOUNT_ID
gp env ACCOUNT_ID="account-id"
```

## refs

[sns subscribe cli](https://docs.aws.amazon.com/cli/latest/reference/sns/subscribe.html#examples)

[put-metric-alarm cli](https://docs.aws.amazon.com/cli/latest/reference/cloudwatch/put-metric-alarm.html)
