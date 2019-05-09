<p class="callout warning">Important: Creation of these resources costs money. Make sure to follow the "When You are Done" section, or the resources will stay and you will be charged.</p>

## Environment Configuration

### Azure Shell (Recommended)
To get running, immediately, with no installation of software, use [Azure Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview).  
[![Launch Azure Cloud Shell](https://shell.azure.com/images/launchcloudshell.png)](https://shell.azure.com/)

From there you can run `git clone https://github.com/kellystuard/azk8terraform` and change to the directory, before following the steps, below.

### PowerShell
If running locally, make sure to log in with `az login` at the beginning of your session and if your session times out. The following programs need to be installed either manually or through a package manager like [Chocolatey](https://chocolatey.org/):
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Helm](https://helm.sh/docs/using_helm/#installing-helm)

Advanced: Multiple options exist for authenticating with Azure: [CLI](https://www.terraform.io/docs/providers/azurerm/auth/azure_cli.html), [Service Identity](https://www.terraform.io/docs/providers/azurerm/auth/managed_service_identity.html), [Service Principal and Client Certificate](https://www.terraform.io/docs/providers/azurerm/auth/service_principal_client_certificate.html), and [Service Principal and Client Secret](https://www.terraform.io/docs/providers/azurerm/auth/service_principal_client_secret.html).

## Installation of Infrastructure (Terraform)
```
pushd terraform/
terraform init
terraform apply -auto-approve
resource_group=$(terraform output resource_group)
aks_name=$(terraform output aks_name)
public_host=$(terraform output public_host)
popd
```

Out of this entire script block, the important line is `terraform apply`. This looks at the desired state (\*.tf), compares it to the state of the cloud, generates a plan to migrate the cloud state to the desired state, and then applies the plan to the cloud.

Note: If `helm install` returns `Error: could not find a ready tiller pod`, wait a few seconds and try again. During the upgrade, Tiller is completely down and no Helm functions will work.

Note: `terraform init` only needs to be run the first time and when providers are changed. If you forget to run it, Terraform will remind you.

## Installation of Applications (Helm)
```
az aks get-credentials --resource-group $resource_group --name $aks_name --overwrite-existing
pushd helm/
helm init --upgrade
helm package aks-helloworld/
helm install aks-helloworld-0.1.0.tgz

watch wget -qO - $public_host
popd
```

Note: if `helm install` returns `Error: could not find a ready tiller pod`, wait a few seconds and try again. During the upgrade, Tiller is completely down and no Helm functions will work.

## When You are Done
```
pushd terraform/
terraform destroy -auto-approve
popd
```
