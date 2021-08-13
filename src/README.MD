<!-- https://markdownlivepreview.com/ -->
# XC Apps with Istio, Terraform and Helm 3
## Prerequisites

- minikube
https://minikube.sigs.k8s.io/docs/start/


- kubectl( v19-20)

https://kubernetes.io/docs/tasks/tools/

- terraform 1.0 ( 0.15.5)
https://www.terraform.io/downloads.html
https://learn.hashicorp.com/tutorials/terraform/install-cli

- HELM 3 

https://helm.sh/docs/intro/install/

- k8s cluster and its context set up properly


## List of files 

| File/Folder  | Purpose |
| ------------- |:-------------:|
| applications.tf     |Terraform & Helm 3 :  file with definition of Helm 3 chart for XC applications     |
| databases.tf     | Terraform & Helm 3 :  file with definition of PostgreSQL & RabbitMQ Helm 3 configuration   |
| istio      |  Helm 3 :  file with definition of Istio compinents   |
| istio.tf     | Kubeconfig file, that will be created by Terrafrom after terraform apply. Can be used to access the cluster    |
| istio.tmpl     | Istio & K8s:  template for Control plane configuration   |
| main.tf     | Terraform : Context , variables and provider configuration   |
| namespaces.tf    | Terraform : Kubernetes namespaces created by terraform   |
| prometheus-kiali.tf   | Terraform : Optional Prometheus and Kiali(for istio) dashboards |
| README.MD   | Documentation + getting started guide  |
| xc-apps  | Helm 3:  chart with XC apps (apigateway,sometext,weather) |




## 1. Minikube configuration



##### 1.1 Start the minikube 

    minikube start --cpus 4 --memory 8192 --network-plugin=cni --cni=calico


Following command : 
  - uses 4 CPUs & 8 GB of memory as we do have many components
  - uses the CNI and Calico as a network plugin addon to support Network Policies

##### 1.2  Verify that minikube Kubernetes cluster is ready 

    ➜  xc-apps git:(main) ✗ kubectl get nodes
    NAME       STATUS   ROLES                  AGE   VERSION
    minikube   Ready    control-plane,master   43h   v1.20.2



### 2. Terraform configuration



##### 2.1 Edit main.tf file 


- Check the correct location of kubeconfig file (context configuration & auth details to K8s cluster) on line 4 of main.tf file

- update the name of the context on line 49 (   config_context_cluster   = "minikube") to the value of your cluster


    

### 3. Initialise the Terraform configuration

##### 3.1 Initilise modules :

    terraform init

##### 3.2 Perform a plan :

    terraform plan


##### 3.3 Perform an apply :

    terraform apply

This command will prompt for confirmation

### 4. Install helm chart

- Way 1 :  Uncomment lines 5-10 in applications.tf, so Terraform deploys it. 
  With this approach, hard to delete and re-install the chart. 
  But editing is ok


- Way 2 :  Use Helm command (prefered method if doing a lot of changes) 

    helm upgrade xcapps  ./xc-apps --values ./xc-apps/values.yaml --install 


### 5. Uninstalllation 

    terraform destroy 
    
Answer "Yes" to the prompt, if you want to proceed with removal



### 6. 


export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}');

export INGRESS_HOST=127.0.0.1;
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT;
curl -s -I -HHost:minikube.local "http://$INGRESS_HOST:$INGRESS_PORT/status/200";

curl -v "http://$INGRESS_HOST:$INGRESS_PORT/api/apiweather/WeatherForecast";

curl -v http://127.0.0.1:30000