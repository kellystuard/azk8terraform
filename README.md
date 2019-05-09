> Important: Azure resources cost money while provisioned. Make sure to follow the "When You are Done" section or the resources will stay and you will be charged.

## Environment Configuration

### Azure Shell (Recommended)
To get running, immediately, with no installation of software, use [Azure Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview).  
[![Launch Azure Cloud Shell](https://shell.azure.com/images/launchcloudshell.png)](https://shell.azure.com/)

From there pick `Bash` from the environment dropdown, run `git clone https://github.com/kellystuard/azk8terraform`, run `cd azk8terraform`, and follow the steps, below.

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

The saving of terraform output to environment variables is used in the next section, where the applications are installed.

> Note: `terraform init` only needs to be run the first time and when providers are changed. If you forget to run it, Terraform will remind you.

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


> Note: If `helm install` returns `Error: could not find a ready tiller pod`, wait a few seconds and try again. During the upgrade, Tiller is completely down and no Helm functions will work. The only reason the upgrade is run, in this example, is that the version of helm installed by Terraform is lower than the version used by the Azure CLI. If you use Terraform to install the Helm chart, these steps would not be necessary.

## Summary
In this example, the provisioning of the infrastructure and the application are separate steps. This is a process decision; there is nothing to prohibit Terraform from running the helm install. It's done here to show how separate teams can manage separate parts of the system using separate tools. Should a fully-automated system be set up where the entirety of the system is tracked in a single repository, it would make sense to have Terraform do all of setup and management. If this is done, the entirity of the demo would be `terraform init && terraform apply -auto-approve`

## When You are Done
```
pushd terraform/
terraform destroy -auto-approve
popd
```
