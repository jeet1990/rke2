#terraform modules code
module "rke2_vsphere_module" {
  source = "./modules/rke2-custom-cluster-module"

  ssh_user = "saan"
  ssh_password = "1990"
  ssh_host = "10.25.74.81"
  rancher_access_key = "token-22pnj"
  rancher_secret_key = "6xwgd9flwz68zmmn6jkh78kqqzfszxvn5t9sh7xqd4dl8vznnknxgm"
  #vm_list = {
	#node_one = { 
            #ssh_user = "saan", 
            #ssh_password = "1990", 
            #ssh_host = "10.25.74.81", 
            #node_role = "--controlplane --etcd --worker" 
           #}
	#node_two = { 
            #ssh_user = "saan",
            #ssh_password = "1990",
            #ssh_host = "10.25.74.82",
            #node_role = "--controlplane --etcd --worker"
           #}
        #node_three = {
            #ssh_user = "saan",
            #ssh_password = "1990",
            #ssh_host = "10.25.74.83",
            #node_role = "--controlplane --etcd --worker"
           #}
        #node_four = {
            #ssh_user = "saan",
            #ssh_password = "1990",
            #ssh_host = "10.25.74.84",
            #node_role = "--worker"
           #}

  #}
}

output "node_cmd" {
     value = module.rke2_vsphere_module.rke2_command
     sensitive = true
}
