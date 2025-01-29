###


resource "helm_release" "cert_manager" {
    repository                                     = "https://charts.jetstack.io"
    name                                           = "cert-manager"
    chart                                          = "cert-manager"
    version                                        = "v${var.v_cert_manager_version}"
    namespace                                      = "cert-manager"
    create_namespace                               = true

    set {
        name                                         = "installCRDs"
        value                                        = true
        }

    # Create Rancher Ingress TLS Secret
        ### checks and if CERT_CHAIN exists, create secret

    provisioner "local-exec" {
      command                                      = "if [ ! -z $CERT_CHAIN ]; then kubectl create ns cattle-system --kubeconfig <(echo $KUBECONFIG | base64 --decode) && kubectl create secret tls tls-rancher-ingress -n cattle-system --cert=$CERT_CHAIN --key=$CERT_KEY --kubeconfig <(echo $KUBECONFIG | base64 --decode); fi"
      #command                                      = "if [ ! -z $CERT_CHAIN ]; then kubectl create secret tls tls-rancher-ingress -n cattle-system --cert=$CERT_CHAIN --key=$CERT_KEY --kubeconfig <(echo $KUBECONFIG | base64 --decode); fi"
      interpreter                                  = ["/bin/bash", "-c"]
      environment                                  = {
        KUBECONFIG                                 = var.v_kube_config_yaml
        CERT_CHAIN                                 = var.v_rancher_ingress_cert
        CERT_KEY                                   = var.v_rancher_ingress_key
      }
    }

    # Create Rancher CA Bundle Secret
        ### checks and if CA_BUNDLE exists, create secret
        
    provisioner "local-exec" {
      command                                      = "if [ ! -z $CA_BUNDLE ]; then kubectl create secret generic tls-ca -n cattle-system --from-file=cacerts.pem=$CA_BUNDLE --kubeconfig <(echo $KUBECONFIG | base64 --decode); fi"
      interpreter                                  = ["/bin/bash", "-c"]
      environment                                  = {
        KUBECONFIG                                 = var.v_kube_config_yaml
        CA_BUNDLE                                  = var.v_rancher_ca_bundle
      }
    }        
}


###


resource "helm_release" "rancher_server" {
    depends_on                                     = [ helm_release.cert_manager ]  

    repository                                     = var.v_rancher_helm_repo
    name                                           = "rancher"
    chart                                          = "rancher"
    version                                        = var.v_rancher_version
    namespace                                      = "cattle-system"
    create_namespace                               = true
    timeout                                        = 600   
    
    set {
        name                                       = "hostname"
        value                                      = var.v_rancher_server_dns
    }

    set {
        name                                       = "certmanager.version"
        value                                      = var.v_cert_manager_version
    }

    set {
        name                                       = "bootstrapPassword"
        value                                      = var.v_rancher_server_admin_password
}

    dynamic "set" {
      for_each                                     = length(var.v_rancher_ingress_cert) > 0 ? [0] : []
      content {
        name                                       = "ingress.tls.source"
        value                                      = "secret"
      }
    }

    dynamic "set" {
      for_each                                     = length(var.v_rancher_ingress_cert) > 0 ? [0] : []
      content {
        name                                       = "privateCA"
        value                                      = true
      }
    }

    dynamic "set" {
      for_each                                     = var.v_rancher_letsencypt_config != {} ? [0] : []
      content {
        name                                       = "ingress.tls.source"
        value                                      = "letsEncrypt"
      }
    }

    dynamic "set" {
      for_each                                     = var.v_rancher_letsencypt_config != {} ? [0] : []
      content {
        name                                       = "letsEncrypt.ingress.class"
        value                                      = "nginx"
      }
    }

    dynamic "set" {
      for_each                                     = var.v_rancher_letsencypt_config != {} ? [0] : []
      content {
        name                                       = "letsEncrypt.email"
        value                                      = var.v_rancher_letsencypt_config.email
      }
    }

    dynamic "set" {
      for_each                                     = var.v_rancher_letsencypt_config != {} ? [0] : []
      content {
        name                                       = "letsEncrypt.environment"
        value                                      = var.v_rancher_letsencypt_config.environment
      }
    }

    values                                         = [<<EOF
ingress                                            : 
  extraAnnotations                                 : 
    nginx.org/websocket-services                   : "rancher"
EOF
    ]
}

# Wait for API to startup, apply ingress certificates if specified
resource "time_sleep" "rancher_api_startup" {
  depends_on                                       = [helm_release.rancher_server]
  create_duration                                  = "30s"
}




# ###

# # Initialize Rancher server
# resource "rancher2_bootstrap" "admin" {
#   depends_on                                       = [time_sleep.rancher_api_startup]
#   provider                                         = rancher2.bootstrap

#   initial_password                                 = var.v_rancher_server_admin_password
#   password                                         = var.v_rancher_server_admin_password
#   telemetry                                        = false
# }