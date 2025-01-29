output "rke2_command" {
     #value = rancher2_cluster_v2.custom_rke2_cluster.cluster_registration_token[0]["node_command"]
      value = format("%s %s", rancher2_cluster_v2.custom_rke2_cluster.cluster_registration_token[0]["node_command"], var.role)
}
