variable v_cert_manager_version {
 description                   = "Version of cert-mananger to install alongside Rancher (format: 0.0.0)"
 type                          = string
 default                       = "1.9.1"
}

variable v_rancher_ingress_cert {
  type                         = string
  description                  = "Path of certificate to be used for Rancher ingress"
  default                      = ""
}

variable v_rancher_ingress_key {
  type                         = string
  description                  = "Path of private key to be used for Rancher ingress"
  default                      = ""
}

variable v_rancher_ca_bundle {
  type                         = string
  description                  = "Path of private CA bundle to be used for Rancher ingress"
  default                      = ""
}

variable v_kube_config_yaml {
  type                         = string
  description                  = "Kube config YAML contents in base64 format"
  default                      = ""
}

variable v_rancher_helm_repo {
  description                  = "URL for the Rancher Helm repository"
  default                      = "https://releases.rancher.com/server-charts/stable"
}

variable v_rancher_version {
  type                         = string
  description                  = "Rancher server version (format: v0.0.0)"
  default                      = "v2.10.1"
}

variable v_rancher_server_dns {
  type                         = string
  description                  = "Rancher server DNS name"
  default = "n6-rancher-ext.ms.hpe.local"
}

variable v_rancher_server_admin_password {
  type                         = string
  description                  = "Admin password to use for Rancher server bootstrap"
  default = "P@ssword@123"
}

variable v_rancher_letsencypt_config {
  description = "Configuration for LetsEncrpyt certificate deployment.  Not required for self-signed or external CA TLS certificates."
  # type                       = object({
  #   environment              = string ( staging | production )
  #   email                    = string
  # })
  default = {}
}