#Need to run in control plane cluster

sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.34.0
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#It will give the join command for worker nodes, example below:-
#sudo kubeadm join 172.31.27.28:6443 --token 16cuco.imj7imdwdz7elszp \
#        --discovery-token-ca-cert-hash sha256:effd262460f3d9ee63c24f486870bd09906dfee9b78a972c737d228106405778

#above command need to run in worker nodes.

#If we are deploying kubenetes setup with kubeadm, we need to do some network steup like using calico

kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml

#Note:- We need to whitelist complete CIDR range in the same vpc, with all traffic.

#Output ➖
#ubuntu@ip-172-31-27-28:~$ kubectl get nodes
#NAME              STATUS   ROLES           AGE   VERSION
#ip-172-31-26-96   Ready    <none>          12m   v1.34.1
#ip-172-31-27-28   Ready    control-plane   37m   v1.34.1
#ip-172-31-29-47   Ready    <none>          12m   v1.34.1
#ubuntu@ip-172-31-27

#As we can see in the roles column for both the worker nodes showing none, we can change the label using the below command.

#ubuntu@ip-172-31-27-28:~$ 
#ubuntu@ip-172-31-27-28:~$ kubectl label node ip-172-31-26-96 node-role.kubernetes.io/worker=k8s-worker-01
#node/ip-172-31-26-96 labeled
#ubuntu@ip-172-31-27-28:~$ kubectl label node ip-172-31-29-47 node-role.kubernetes.io/worker=k8s-worker-01
#node/ip-172-31-29-47 labeled
#ubuntu@ip-172-31-27-28:~$ 
#ubuntu@ip-172-31-27-28:~$ kubectl get nodes
#NAME              STATUS   ROLES           AGE   VERSION
#ip-172-31-26-96   Ready    worker          26m   v1.34.1
#ip-172-31-27-28   Ready    control-plane   52m   v1.34.1
#ip-172-31-29-47   Ready    worker          26m   v1.34.1
#ubuntu@ip-172-31-27-28:~$ 
#ubuntu@ip-172-31-27-28:~$ 


#Service type clusterIP :- is responsible for pod to pod communication, it will not exposed the server access outside the world.

#Service type NodePort :- we can use this to access our application over the internet :- (it will run on any specific port with a big range.)

#ubuntu@ip-172-31-27-28:~$ kubectl get svc
#NAME            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
#kubernetes      ClusterIP   10.96.0.1       <none>        443/TCP        117m
#nginx-service   NodePort    10.97.139.134   <none>        80:31982/TCP   55m
#ubuntu@ip-172-31-27-28:~$ 

#Configuration of metrics server for geting resource uses by pods and nodes

#Using this we can download and install
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

#But after this our metrics server pods will stopped state due to tls error.

#In this case we will edit the deployment file.

#kubectl edit deployment metrics-server -n kube-system

#Just include below line in arguments.

- --kubelet-insecure-tls

#After that it will automatically create new pods with running status.

#Example - 
#ubuntu@ip-10-1-1-66:~$ kubectl top nodes
#NAME            CPU(cores)   CPU(%)   MEMORY(bytes)   MEMORY(%)   
#ip-10-1-1-66    103m         5%       875Mi           22%         
#ip-10-1-3-110   32m          1%       512Mi           13%         
#ip-10-1-3-91    39m          1%       543Mi           14%        
#ubuntu@ip-10-1-1-66:~$ 
#ubuntu@ip-10-1-1-66:~$ 


#helm installation

sudo apt-get install curl gpg apt-transport-https --yes
curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
#   27  kubectl get ns
#   28  kubectl get all -n ingress-nginx
#   29  kubectl get ing  -n chat-app
#   30  cat ingress.yml 

#Ingress Setup (Using Nginx Ingress Controller)
#We can use helm chart for installing ingress-nginx controller
helm upgrade --install ingress-nginx ingress-nginx   --repo https://kubernetes.github.io/ingress-nginx   --namespace ingress-nginx --create-namespace   
kubectl get all -n ingress-nginx
kubectl get ingressclass
#We can delete the validating webhook configuration if we are facing any issue while creating ingress resources.
#kubectl delete validatingwebhookconfiguration ingress-nginx-admission  
kubectl delete validatingwebhookconfiguration ingress-nginx-admission
