## Installation of Infrastructure (Terraform)
```
cd terraform/
terraform init
terraform apply -auto-approve -var 'environment=demo'
cd ..
```

### Installation of Applications (Helm)
```
az aks get-credentials --resource-group k8s --name azk8-ingress --overwrite-existing
cd helm/
helm init --upgrade
helm package aks-helloworld/
helm install aks-helloworld-0.1.0.tgz

watch wget -qO - http://azk8terraform-demo.centralus.cloudapp.azure.com
```
