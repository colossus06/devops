# Week 1 — App Containerization

![image](https://user-images.githubusercontent.com/96833570/220974392-3c15481b-f5b1-49c0-bf52-2c9f4d74765c.png)

[lucid.app share link](https://lucid.app/lucidchart/61c14870-6ad9-486e-868a-04f85b5bc501/edit?invitationId=inv_8ec00958-a2e7-4f8c-b61a-f9384f082d8b&page=0_0#)


### Summary

This week I worked on the following:

* Cloned, containerized Application frontend/backend using dockerfiles  and `docker-compose.yml`.
* Created `/api/activities/notifications` endpoint in flask
* Wrote notifications page in react
* Installed postgressql client to gitpod
* Run, ensure DynamoDB Local Container and Postgres works.
* Run cruddur locally and integrated backend with frontend
* Implement a healthcheck using wget in Docker compose file
* Created a multistage dockerfile for a simple react app, containerized and pushed to dockerhub
* Pulled this image and run on aws ec2


### App Containerization

I added the following to `app.py`

```
if __name__ == "__main__":
  app.run(debug=True, host="0.0.0.0", port=8000)
```

Exported the backend url:

`export BACKEND_URL="*"`

And run the api on `/api/activities/home` endpoint:

```
cd backend-flask
export FRONTEND_URL="*"
export BACKEND_URL="*"
python -m flask run --host=0.0.0.0 --port=8000
```

![image](https://user-images.githubusercontent.com/96833570/220427575-ed48df84-31ba-42ff-b81f-c4b791a8259d.png)



![image](https://user-images.githubusercontent.com/96833570/220427593-c8579900-758b-4fbb-8d69-8fbe954bc3d0.png)

### Containerizing the backend

```
docker build -t  backend-flask ./backend-flask
```
![image](https://user-images.githubusercontent.com/96833570/220430406-9a80e3ba-4f07-41bd-91e4-4213d8aafac1.png)

### Debug time

I ran `docker run -p 4567:4567 backend-flask` and checked if environment variables are set.

`docker exec -it 7e48fe8784b1 bash`

![image](https://user-images.githubusercontent.com/96833570/220431135-67bd3892-f7b8-4d09-adb4-9b5502db61c2.png)


I saw that i didn't set the envs so i got `404` error.  https://http.cat/[404]

![image](https://user-images.githubusercontent.com/96833570/220431901-b96bad1d-c8cc-4344-a580-8941ef847d30.png)

I specified env variables implicitly on command line:

`docker run --rm -p 4567:4567 -it -e FRONTEND_URL='*' -e BACKEND_URL='*' backend-flask`

Verified by attaching a shell:

![image](https://user-images.githubusercontent.com/96833570/220436340-17936104-956a-4151-9ae9-1d0ce83f4348.png)

Verified with `curl`:

![image](https://user-images.githubusercontent.com/96833570/220436539-16b437b7-bf29-4d63-950e-22168a2ca2c2.png)


Let's continue with the frontend

## Containerizing frontend

```
cd frontend-react-js
npm i
cd ..
docker-compose up
```

My terminal got hang up. I restarted my gitpod.

![image](https://user-images.githubusercontent.com/96833570/220440069-77da608d-5bec-4c99-9e6b-308c98a7167a.png)

![image](https://user-images.githubusercontent.com/96833570/220456784-174d49c4-9a19-4eed-97c3-9d0467252369.png)


### Creating the notification feature

#### Backend

Edited the open api file, app.py and created `notifications_activities.py` file on service dir.

![image](https://user-images.githubusercontent.com/96833570/220624279-9f5aec06-475e-4881-897a-f5a246f650ea.png)


![image](https://user-images.githubusercontent.com/96833570/220623834-8a268924-2c6c-499c-a07d-ff892f75673d.png)


#### Frontend

![image](https://user-images.githubusercontent.com/96833570/220626642-68f52f34-08f6-4518-bfbb-83d03720ba4f.png)


![image](https://user-images.githubusercontent.com/96833570/220626393-e22c941b-4811-4082-b166-a0d95aeaaeb6.png)

After a little more adjustment:

![image](https://user-images.githubusercontent.com/96833570/220627194-6af1a9f7-c733-4d5b-b6a8-95264aadda1d.png)


Uploaded the open-api.yml file on swagger.io:

![image](https://user-images.githubusercontent.com/96833570/220629917-724f2fdd-9a32-45b8-bafa-80be68f0f571.png)

### Security considerations

Scanned our app with Synk

![image](https://user-images.githubusercontent.com/96833570/220627730-9eb970ab-56fd-43d6-99db-5a72395f8da3.png)

![image](https://user-images.githubusercontent.com/96833570/220627780-adb576c2-db3f-4af4-b98c-1797aa8f0f42.png)


### Run DynamoDB Local Container and ensure it works

I used [these codes](https://github.com/100DaysOfCloud/challenge-dynamodb-local):

![image](https://user-images.githubusercontent.com/96833570/220646019-3c96fba0-1277-4ad5-88c5-7ff96fc1be88.png)

```
aws dynamodb scan --table-name Music --query "Items" --endpoint-url http://localhost:8000

```

### Psql


![image](https://user-images.githubusercontent.com/96833570/220661708-ea81babf-9d10-4ce8-a7c8-00f88bba3719.png)

`psql -Upostgres --host localhost`

![image](https://user-images.githubusercontent.com/96833570/220666017-b8e8fd22-9dd8-4273-aebe-7b9b70d529fe.png)

### Push and tag a image to DockerHub

![image](https://user-images.githubusercontent.com/96833570/220670230-9f7c1ae8-e0fc-46ad-bf06-c6ec32d9d69c.png)

Pushed the backend-flask to dockerhub:

![image](https://user-images.githubusercontent.com/96833570/220670639-d56106c6-0cb4-48a5-9c74-9359e8c19e07.png)

![image](https://user-images.githubusercontent.com/96833570/220670772-fd423707-2799-46b0-8848-860b72cff2cf.png)

### Build and run the app locally

I couldn't make cruddur's front and backend integration. So, i started a simple flask and react app just to see how can i display backend data on port 3000.

![image](https://user-images.githubusercontent.com/96833570/220901053-5c6f8cca-26d5-47c0-b858-b42e5c824830.png)



#### Multistage dockerfile/get the same containers running outside of Gitpod / Codespaces

* I could run all the containers locally, but couldn't integrate the front and backends

* I created a react app and run it locally, then dockerized it using node image.

![image](https://user-images.githubusercontent.com/96833570/220913464-ad8537e4-c4b3-4ef8-8743-aaeccd8c9925.png)

Tried to debug `syntaxerror unexpected token eslint-webpack-plugin` error. downgrading the plugin version or upgrading np didn't work. I experimented changing node version from 10 to 16.18 and it worked.

![image](https://user-images.githubusercontent.com/96833570/220960543-2953c982-ceb7-4700-b574-43941f59af16.png)

Then created a multistage dockerfile for react app. 

![image](https://user-images.githubusercontent.com/96833570/220967038-2161808a-aee7-4f26-a32b-b456fa926ae5.png)

Pushed this image to my dockerhub to test on aws

### Launch an EC2 instance that has docker installed, and pull a container to demonstrate you can run your own docker processes.

I started an ec2 with user data and verified that docker is running:

![image](https://user-images.githubusercontent.com/96833570/220963085-6280815f-19d2-44c9-8cc5-c4f191f2d3f2.png)

I named the image wrong but was able to reduce the image size considerable thanks to multi stage docker file

![image](https://user-images.githubusercontent.com/96833570/220972876-b53cadc5-0434-4ab2-9837-a5407a59d35d.png)

Pulled and run on ec2:

![image](https://user-images.githubusercontent.com/96833570/220973281-cf01c203-cfc0-45a8-987d-47ce2abe0f07.png)

![image](https://user-images.githubusercontent.com/96833570/220973706-cf81940d-1c72-4f06-9e86-de1a01ad074d.png)



### Implement a healthcheck in the V3 Docker compose file

My frontend container was unhealthy in a couple tries. I attached a shell and saw that curl wasn't installed on it, used `wget` instead.

![image](https://user-images.githubusercontent.com/96833570/220691892-d52eebca-f314-404b-b6b4-1574d037d97e.png)

```
    healthcheck:
      test: wget --no-verbose --tries=1 --spider http://localhost:3000 || exit 1
      interval: 30s
      retries: 5
      start_period: 10s
      timeout: 10s
```

![image](https://user-images.githubusercontent.com/96833570/220697149-a8bc11c8-9c5f-4c07-baa4-82bc5d9da421.png)


#### Takeaways

```
#identify what process id is using a port
lsof -P -i :5000

container escape// more on this



```