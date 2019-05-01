Important: Creation of these resources costs money. Make sure to follow the "When You are Done" section, or the resources will stay and you will be charged.

## Installation of Infrastructure (Terraform)
```
pushd terraform/
terraform init
terraform apply -auto-approve
resource_group=$(terraform output resource_group)
aks_name=$(terraform output aks_name)
public_ip=$(terraform output public_ip)
popd
```
Note: `terraform init` only needs to be run the first time and when providers are changed. If you forget to run it, Terraform will remind you.

### Installation of Applications (Helm)
```
az aks get-credentials --resource-group $resource_group --name $aks_name --overwrite-existing
pushd helm/
helm init --upgrade
helm package aks-helloworld/
helm install aks-helloworld-0.1.0.tgz

watch wget -qO - $public_ip
popd
```
Note: if `helm install` returns `Error: could not find a ready tiller pod`, wait a few seconds and try again. During the upgrade, Tiller is completely down and no Helm functions will work.

### When You are Done
```
pushd terraform/
terraform destroy -auto-approve
popd
```
