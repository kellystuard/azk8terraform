## Installation of Infrastructure (Terraform)
```
cd terraform/
terraform init
terraform apply -auto-approve
resource_group=$(terraform output resource_group)
aks_name=$(terraform output aks_name)
cd ..
```

### Installation of Applications (Helm)
```
az aks get-credentials --resource-group $(resource_group) --name $(aks_name) --overwrite-existing
cd helm/
helm init --upgrade
helm package aks-helloworld/
helm install aks-helloworld-0.1.0.tgz

watch wget -qO - http://azk8terraform-demo.centralus.cloudapp.azure.com
```
