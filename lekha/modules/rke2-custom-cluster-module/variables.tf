
variable "ssh_user" {
       type = string
       description = "ssh username"
}


variable "ssh_password" {
       type = string
       description = "ssh password"
       sensitive = true
}


variable "ssh_host" {
       type = string
       description = "vm ipv4 address"
}

variable "rancher_access_key" {
         type = string
         sensitive = true

}

variable "rancher_secret_key" {
          type = string
          sensitive = true


}

variable "role" {
       type = string
       default = "--controlplane --worker --etcd"
}

#variable "vm_list" {
 # type = map(object({
  #      ssh_host = string
   #     ssh_user = string
    #    ssh_password = string
     #   node_role = string
 # }))
#}

