# Week 6 — Deploying Containers

## Summary

This week i worked on the following and wrote an article on linkedin covering the ECS part I.

* Provisioned an ECS Cluster, ECR repos. Pushed images for backend-flask, base-python, frontend-react, base-node.
* Deployed Backend Flask app and React JS app as a service to Fargate
* Secured flask against arbitrary code execution by not running in debug mode.
* Change Docker Compose file to explicitly use a user-defined network named cruddur-net.
* Created Dockerfiles pecfically for production use case	
* Configured Application Load Balancer along with target groups and rules.
* Managed my subdomains useing Route53 via hosted zone and domain using Google Domains
* Created an SSL cerificate via ACM.
* Set a subdomain named `app` to point to the frontend and another one named `api.app` for the backend.
* RefactorED bin directory to be top level
* Implemented Refresh Token for Amazon Cognito
* Configured CORS to only permit traffic from our domain substituting wildcards with my app and api subdomains.
### ECS Fargate

I edited dockerfiles to pull from ecr and verified newly created endpoint.


![](images/images/20230404181101.png)


Debugging: `nsoleLogger.ts:105 [ERROR] 39:36.527 AuthError - 
            Error: Amplify has not been configured correctly. 
 ` error:

![](images/images/20230411214359.png)



I deployed the backend flask to ecs fargate using ECR hosted images. Got a shell in the container using session manager plugin:


![](images/20230414224752.png)


Below was cruddur logs:

![](images/20230414224815.png)

Then deployed frontend to ecs after registering the task definition and creating the service.

![](images/20230415172318.png)

Tested frontend with ALB:

![](images/20230415180333.png)

Configured loab balancer, ssl certificate manager for front and backends:

![](images/20230415203256.png)

When I deployed the app to ecs with load balancer and ssl setup I got the following error:

![](images/20230416001317.png)

I edited my environment variables and deployed again.

![](images/20230416133902.png)

I could verify that my environment variables are set correctly and configured load balancer rules and routes properly.

My backend was on another subdomain:

![](images/20230416134022.png)


Note: Before deploying to ecs:

* chage http://localhost:4567 in src to http://localhost:4567 and vice versa for local. I will try to solve this issue along the way. Otherwise all domains seem as localhost:3000

![](images/20230416160613.png)