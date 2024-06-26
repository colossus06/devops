# Week 2 — Distributed Tracing


### Summary

Week 2 in a nutshell:

* Integrated Open Telemetry (OTEL)  with backend using Honeycomb and monitored traces.
* Integrated AWS X-Ray and X-Ray daemon within docker-compose, monitored traces.
* Integrated Rollbar,triggered an error and observe with Rollbar
* Lastly installed WatchTower and wrote and monitored a custom logger with CloudWatch.


This week i worked with completely new tools and domains such as OTEL, AWS X-Ray, honeycomb, WatchTower, Rollbar.

## Implementing Xray

I could run the app after a lot of debug with gitpod. 

![image](https://user-images.githubusercontent.com/96833570/221530709-301e7f0e-337b-4018-8b6e-48630063bb09.png)

I created an xray group and sampling rule. Head over to the management console to see some data.

![image](https://user-images.githubusercontent.com/96833570/221534752-29519423-5099-4630-a8c4-1cf57023bd52.png)


![image](https://user-images.githubusercontent.com/96833570/221542418-68535f33-9a64-471f-94a0-96b09054aa9b.png)

![image](https://user-images.githubusercontent.com/96833570/221546388-a468f71d-03bd-45a7-8f50-9a1df8b1ec58.png)

When i'm done i commented out the code related to this section.


## Implementing Honeycomb





![image](https://user-images.githubusercontent.com/96833570/221415631-c6b5b6cb-0d7a-4a59-9562-45addef4befd.png)


## Implementing CloudWatch Logs, install WatchTower, write a custom logger


![image](https://user-images.githubusercontent.com/96833570/221552361-53cf39db-3401-4d5e-9859-2c322f06096b.png)


![image](https://user-images.githubusercontent.com/96833570/221552703-2c3b192a-1c27-4fc6-a78a-862b18400ac2.png)

When i'm done i commented out the code related to this section.

## Integrate Rollbar for Error Logging

![image](https://user-images.githubusercontent.com/96833570/222068789-e59f32f8-d4a7-4b76-9dc1-bcbb0ed3a1b1.png)

![image](https://user-images.githubusercontent.com/96833570/222069023-25b1fe39-178e-48c3-9420-cd389a58587e.png)


![image](https://user-images.githubusercontent.com/96833570/222079701-37729416-1868-47e5-9507-92b980f75124.png)


![image](https://user-images.githubusercontent.com/96833570/222079651-d896474a-c469-4af8-ba98-f9cd1065f10a.png)



