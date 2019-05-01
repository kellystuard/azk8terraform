## Installation of Infrastructure (Terraform)
```
cd terraform/
terraform init
terraform apply -auto-approve
resource_group=$(terraform output resource_group)
aks_name=$(terraform output aks_name)
public_ip=$(terraform output public_ip)
cd ..
```

### Installation of Applications (Helm)
```
az aks get-credentials --resource-group $resource_group --name $aks_name --overwrite-existing
cd helm/
helm init --upgrade
helm package aks-helloworld/
helm install aks-helloworld-0.1.0.tgz

watch wget -qO - $public_ip
```
