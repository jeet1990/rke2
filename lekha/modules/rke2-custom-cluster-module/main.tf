terraform {
   required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      #version = "4.2.0"
    }
 }
}

provider "rancher2" {
  api_url    = "https://n0-rancher-ext.ms.local.hpe"
  access_key = var.rancher_access_key
  secret_key = var.rancher_secret_key
  insecure = true
}



resource "rancher2_cluster_v2" "custom_rke2_cluster" {
  name = "rke2-dev05"
  kubernetes_version = "v1.30.6+rke2r1"
  rke_config {
    machine_global_config = yamlencode({
      cni = "flannel"
      #disable-kube-proxy = false
      #etcd-expose-metrics = false
      #kube-apiserver-arg = local.kube_apiserver_arg
    })
    upgrade_strategy {
      control_plane_concurrency = "15%"
      worker_concurrency = "15%"
    }
    etcd {
      snapshot_schedule_cron = "0 */5 * * *"
      snapshot_retention = 20
    }
}
}


resource "null_resource" "rke2_node_config1" {
  #for_each = var.vm_list

  provisioner "remote-exec" {
    connection {
      host = var.ssh_host
      user = var.ssh_user
      password = var.ssh_password
      #host = each.value["ssh_host"]
      #user = each.value["ssh_user"]
      #password = each.value["ssh_password"]
      timeout  = "30m"
    }

    inline = [
              "echo '1990' | sudo -S su",
               format("%s %s",rancher2_cluster_v2.custom_rke2_cluster.cluster_registration_token[0]["insecure_node_command"],var.role)

               #format("%s %s",rancher2_cluster_v2.custom_rke2_cluster.cluster_registration_token[0]["insecure_node_command"],each.value["node_role"])
    ]
  }
}
##################################################

