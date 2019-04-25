provider "helm" {
  version = "~> 0.9"
  
  kubernetes {
    host                   = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
    client_certificate     = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)}"
    client_key             = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)}"
  }
}

provider "tls" {
  version = "~> 2.0"
}

resource "helm_release" "nginx" {
  name    = "nginx"
  chart   = "stable/nginx-ingress"
  #version = ""
  namespace = ingress-basic
  
  set {
    name  = "rbac.create"
    value = "false"
  }
  set {
    name = "controller.replicaCount"
    value = "3"
  }
  values = [<<EOF
controller:
  service:
    loadBalancerIP: ${local.azurerm_subnet_k8s_lb_ip_address}
    annotations:
      service.beta.kubernetes.io/azure-load-balancer-internal: "true"
EOF
  ]
}

data "helm_repository" "azure-samples" {
    name = "azure-samples"
    url  = "https://azure-samples.github.io/helm-charts/"
}

resource "helm_release" "aks-helloworld" {
    name       = "aks-helloworld"
    repository = "${data.helm_repository.azure-samples.metadata.0.name}"
    chart      = "aks-helloworld"
    namespace = ingress-basic
    
    set {
      name  = "serviceName"
      value = "aks-helloworld"
    }
    set {
      name  = "title"
      value = "Base URL hit"
    }
}

resource "helm_release" "aks-helloworld" {
    name       = "aks-helloworld1"
    repository = "${data.helm_repository.azure-samples.metadata.0.name}"
    chart      = "aks-helloworld"
    namespace = ingress-basic
    
    set {
      name  = "serviceName"
      value = "aks-helloworld1"
    }
    set {
      name  = "title"
      value = "URL /hello1 hit"
    }
}

resource "helm_release" "aks-helloworld" {
    name       = "aks-helloworld2"
    repository = "${data.helm_repository.azure-samples.metadata.0.name}"
    chart      = "aks-helloworld"
    namespace = ingress-basic
    
    set {
      name  = "serviceName"
      value = "aks-helloworld2"
    }
    set {
      name  = "title"
      value = "URL /hello2 hit"
    }
}

# Found at: https://github.com/kubernetes/kubernetes/blob/master/pkg/cloudprovider/providers/azure/azure_loadbalancer.go#L38

# ServiceAnnotationLoadBalancerInternal is the annotation used on the service
# "service.beta.kubernetes.io/azure-load-balancer-internal"

# ServiceAnnotationLoadBalancerInternalSubnet is the annotation used on the service
# to specify what subnet it is exposed on
# "service.beta.kubernetes.io/azure-load-balancer-internal-subnet"

# ServiceAnnotationLoadBalancerMode is the annotation used on the service to specify the
# Azure load balancer selection based on availability sets
# There are currently three possible load balancer selection modes :
# 1. Default mode - service has no annotation ("service.beta.kubernetes.io/azure-load-balancer-mode")
#    In this case the Loadbalancer of the primary Availability set is selected
# 2. "__auto__" mode - service is annotated with __auto__ value, this when loadbalancer from any availability set
#    is selected which has the minimum rules associated with it.
# 3. "as1,as2" mode - this is when the load balancer from the specified availability sets is selected that has the
#    minimum rules associated with it.
# "service.beta.kubernetes.io/azure-load-balancer-mode"

# ServiceAnnotationLoadBalancerAutoModeValue is the annotation used on the service to specify the
# Azure load balancer auto selection from the availability sets
# "__auto__"

# ServiceAnnotationDNSLabelName is the annotation used on the service
# to specify the DNS label name for the service.
# "service.beta.kubernetes.io/azure-dns-label-name"

# ServiceAnnotationSharedSecurityRule is the annotation used on the service
# to specify that the service should be exposed using an Azure security rule
# that may be shared with other service, trading specificity of rules for an
# increase in the number of services that can be exposed. This relies on the
# Azure "augmented security rules" feature.
# "service.beta.kubernetes.io/azure-shared-securityrule"

# ServiceAnnotationLoadBalancerResourceGroup is the annotation used on the service
# to specify the resource group of load balancer objects that are not in the same resource group as the cluster.
# "service.beta.kubernetes.io/azure-load-balancer-resource-group"

# ServiceAnnotationAllowedServiceTag is the annotation used on the service
# to specify a list of allowed service tags separated by comma
# "service.beta.kubernetes.io/azure-allowed-service-tags"

# ServiceAnnotationLoadBalancerIdleTimeout is the annotation used on the service
# to specify the idle timeout for connections on the load balancer in minutes.
# "service.beta.kubernetes.io/azure-load-balancer-tcp-idle-timeout"

# ServiceAnnotationLoadBalancerMixedProtocols is the annotation used on the service
# to create both TCP and UDP protocols when creating load balancer rules.
# "service.beta.kubernetes.io/azure-load-balancer-mixed-protocols"
