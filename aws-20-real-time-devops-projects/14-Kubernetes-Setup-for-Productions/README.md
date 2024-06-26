# 16-Kubernetes-Setup-for-productions

![](20230706181825.png)


For kubeadm installation using containerd on EC2 take a look at  `kubeadm-2023`.

## Minikube environment for testing

```
minikube status
eval $(minikube -p minikube docker-env)
kubectl create deployment web --image=gcr.io/google-samples/hello-app:1.0
kubectl get deployments
kubectl get pods
```

![image](https://user-images.githubusercontent.com/96833570/221562064-100866ca-30a1-4af5-801b-a6e0f94e5a3b.png)

When you describe the pod with `kubectl describe pod hello-minikube-844fbb9876-n8x9x`:

![image](https://user-images.githubusercontent.com/96833570/221564734-3d87677c-242d-45e3-9f8f-db40aed48871.png)

![image](https://user-images.githubusercontent.com/96833570/221588149-bac58f3b-7426-4fa5-9062-27bed22cdbfe.png)


```
kubectl expose deployment web --type=NodePort --port=8080
kubectl get service web
minikube service web --url
```

![image](https://user-images.githubusercontent.com/96833570/221588431-0583abdf-536c-4581-9dd8-f9245a35748c.png)

`minikube delete`

![image](https://user-images.githubusercontent.com/96833570/221588821-6e2fb5b3-8238-4e63-a413-4177efbfca41.png)




## KOPS env for production

Create a bucket

```
aws s3api create-bucket \
    --bucket kops-bucket-rrrandom \
    --region us-east-1
```

![image](https://user-images.githubusercontent.com/96833570/221595464-283d93f0-16bc-4985-b468-35f9f48acc0b.png)

`nslookup -type=ns k8s.devtechops.dev`

![image](https://user-images.githubusercontent.com/96833570/221597041-10ee7712-8d87-4d64-bbdf-48b53a57642f.png)

Install kubectl

```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

```

Install kops

```
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops
sudo mv kops /usr/local/bin/kops
```

## Create cluster


```
  export KOPS_STATE_STORE="s3://kops-bucket-rrrandom"
  export MASTER_SIZE="t3.medium"
  export NODE_SIZE="t3.small"
  export ZONES="us-east-1a"
  kops create cluster k8s.devtechops.dev\
  --node-count 2 \
  --zones $ZONES \
  --node-size $NODE_SIZE \
  --master-size $MASTER_SIZE \
  --master-zones $ZONES \
  --yes
```


```
kops update cluster --name k8s.devtechops.dev --yes
kops export kubecfg --admin
```

```
kops validate cluster --name  k8s.devtechops.dev --state=s3://kops-bucket-rrrandom
```

```
aws ec2 create-volume \
    --volume-type gp2 \
    --size 3 \
    --availability-zone us-east-1a
```

Take a note of your volume id: vol-00aa162077fd5a69c

```
kubectl get nodes --show-labels
kubectl get nodes
kubectl describe node ip<>
kubectl label nodes ip<> zone=us-east-1a

kubectl create -f secret.yaml
kubectl get secret
kubectl describe secret


 kubectl create -f dbdep.yaml
 kubectl create -f .

```

![image](https://user-images.githubusercontent.com/96833570/222981563-1bba8788-6020-4135-b2fb-2ca940dfc3d1.png)

![image](https://user-images.githubusercontent.com/96833570/222981670-4c89a510-d977-41a5-b355-5fc28a72cbfc.png)


![image](https://user-images.githubusercontent.com/96833570/221618935-22531589-2884-4ced-963d-4fd54b637cea.png)


```
kops delete cluster --name k8s.devtechops.dev --state=s3://kops-bucket-rrrandom --yes
```


## Debugging 

```
error: failed to create deployment: Post "https://kubernetes.docker.internal:6443/apis/apps/v1/namespaces/default/deployments?fieldManager=kubectl-create&fieldValidation=Strict": dial tcp 127.0.0.1:6443: connectex: No connection could be made because the target machine actively refused it.
```

I got this error and solved simply by starting docker on windows.



## REf

https://kubernetes.io/docs/tutorials/hello-minikube/

## Useful commands

```
kops create cluster --help
kops export kubecfg --admin
```
