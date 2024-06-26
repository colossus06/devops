# Week 3 — Decentralized Authentication


Summary:

This week I worked on the following:

* Installed and configured Amplify client-side library for Amazon Congito
* Implemented API calls to Amazon Coginto for custom login, signup, recovery and forgot password page
* Showed conditional elements and data based on logged in or logged out

<br>

Started this week with a quick hands-on before the week3 video.

<p align="center">
  <img src="https://user-images.githubusercontent.com/96833570/222895419-1badd100-7e06-45e3-b00f-4b5154a25910.png"/>
</p>

![image](https://user-images.githubusercontent.com/96833570/222895825-182f5403-8c48-4099-8567-9681875b46ae.png)

After setting up a user pool launched UI

![image](https://user-images.githubusercontent.com/96833570/222896401-c683fec3-b91c-4294-88ee-3bd78890ab8f.png)

![image](https://user-images.githubusercontent.com/96833570/222896451-d8891bf8-b842-4601-b369-5d420e1bea2c.png)

* index page a href: 
* login page a href: https://adaapp.auth.us-east-1.amazoncognito.com/logout?client_id=2k0d83p8urdhom12spburchomf&logout_uri=http://localhost:8000/logged_out.html


![image](https://user-images.githubusercontent.com/96833570/222896643-b8945716-429e-493a-965b-91eb050912fd.png)

![image](https://user-images.githubusercontent.com/96833570/222896684-031b60b1-cbbd-4b0b-967e-477431f906e7.png)

![image](https://user-images.githubusercontent.com/96833570/222896699-46a387d7-2441-4899-b828-4b365750d3ba.png)

Switched back to cognito to see my users in the pool before destroying the resources

![image](https://user-images.githubusercontent.com/96833570/222896763-5e088955-7896-4871-aebc-442472d863b2.png)


![image](https://user-images.githubusercontent.com/96833570/222896711-0fe1bb3f-81b8-4491-a883-8a0ecefb8c18.png)

![image](https://user-images.githubusercontent.com/96833570/222896718-c405315c-8e31-4f19-9097-0cbad340772b.png)


### Starting week 3

Implemented amplify and made sure the app is working again.

![image](https://user-images.githubusercontent.com/96833570/224272882-85d2a713-f863-47c1-bf98-483c11baca7b.png)

After a great amount of debugging i came to the yaayy part on which i could see the error on the UI.

![image](https://user-images.githubusercontent.com/96833570/224367240-97fd6984-4d5c-4339-8bcd-6835913daf2d.png)

### Sign-in page

After creating a user on the management console and `admin-set-user-password` command, i could sign in to the app.

![image](https://user-images.githubusercontent.com/96833570/224422123-a4e81e74-882c-4cd2-9056-ba1f86806977.png)


### Signup page

![image](https://user-images.githubusercontent.com/96833570/224428341-2a823c37-3e2e-474d-a613-0501dc28ac34.png)

![image](https://user-images.githubusercontent.com/96833570/224428361-95b7a76e-2a1d-4468-ba5f-b686a19e45a8.png)


### Recovery Page


![image](https://user-images.githubusercontent.com/96833570/224430140-7145f96e-eba2-4c86-9bff-c9c0059bd7f2.png)


```

aws cognito-idp list-user-pools --max-results 20
aws sts get-caller-identity
aws configure
aws cognito-idp create-user-pool --pool-name MyUserPool
aws cognito-idp admin-set-user-password --user-pool-id us-east-xx --password xxx --username john --permanent --region us-east-1
```



### Integrating cognito jwt server side verification

This week i worked on backend implementation of cognito. I passed the header adn validated jwt. Then updated requirements.txt and initialized cognito_jwt_token


![image](https://user-images.githubusercontent.com/96833570/226110535-ebe1603e-3ca6-44ae-9ddf-54a8f80a4537.png)

![image](https://user-images.githubusercontent.com/96833570/226113369-bd1064b8-63ff-4bee-8219-744b395ba974.png)

