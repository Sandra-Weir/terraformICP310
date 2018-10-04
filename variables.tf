# Username and password for the initial admin user
variable "icp-master" {
  type        = "list"
  description = "IP address of ICP Masters. First master will also be boot master. CE edition only supports single master "
}

variable "icp-worker" {
  type        = "list"
  description = "IP addresses of ICP Worker nodes."
}

variable "icp-proxy" {
  type        = "list"
  description = "IP addresses of ICP Proxy nodes."
}

variable "icp-management" {
  type        = "list"
  description = "IP addresses of ICP Management nodes."
}

variable "icp-va" {
  type        = "list"
  description = "IP addresses of ICP VA nodes."
}

variable "enterprise-edition" {
  description = "Whether to provision enterprise edition (EE) or community edition (CE). EE requires image files to be provided"
  default     = false
}

variable "parallell-image-pull" {
  description = "Download and pull docker images on all nodes in parallell before starting ICP installation."
  default     = false
}

variable "image_file" {
  description = "Filename of image. Only required for enterprise edition"
  default     = "/dev/null"
}

variable "image_location" {
  description = "Alternative to image_file, if image is accessible to the new vm over nfs or http"
  default     = "false"
}
variable "docker_package_location" {
  description = "http or nfs location of docker installer which ships with ICP. Option for RHEL which does not support docker-ce"
  default     = ""
}

variable "icp-version" {
  description = "Version of ICP to provision. For example 2.1.0, 2.1.0-ee"
  default     = "2.1.0"
}

variable "ssh_user" {
  description = "Username to ssh into the ICP cluster. This is typically the default user with for the relevant cloud vendor"
  default     = "root"
}

variable "ssh_key" {
  description = "Private key corresponding to the public key that the cloud servers are provisioned with"
  default     = "~/.ssh/id_rsa"
}

variable "ssh_key_base64" {
  description = "base64 encoded content of private ssh key"
  default     = ""
}

variable "ssh_key_file" {
  description = "Location of private ssh key. i.e. ~/.ssh/id_rsa"
  default     = ""
}

variable "ssh_agent" {
  description = "Enable or disable SSH Agent. Can correct some connectivity issues. Default: true (enabled)"
  default     = true
}

variable "bastion_host" {
  description = "Specify hostname or IP to connect to nodes through a SSH bastion host. Assumes same SSH key and username as cluster nodes"
  default     = ""
}

variable "generate_key" {
  description = "Whether to generate a new ssh key for use by ICP Boot Master to communicate with other nodes"
  default     = false
}

variable "icp_pub_keyfile" {
  description = "Public ssh key for ICP Boot master to connect to ICP Cluster. Only use when generate_key = false"
  default     = "/dev/null"
}

variable "icp_priv_keyfile" {
  description = "Private ssh key for ICP Boot master to connect to ICP Cluster. Only use when generate_key = false"
  default     = "/dev/null"
}

variable "cluster_size" {
  description = "Define total clustersize. Workaround for terraform issue #10857."
}

variable "proxy_size" {
  default     = 0
}

variable "management_size" {
  default     = 0
}

variable "va_size" {
  default     = 0
}

variable "worker_size" {
  default     = 0
}

/*
  ICP Configuration 
  Configuration file is generated from items in the following order
  1. config.yaml shipped with ICP (if config_strategy = merge, else blank)
  2. config.yaml specified in icp_config_file
  3. key: value items specified in icp_configuration

*/
variable "icp_config_file" {
  description = "Yaml configuration file for ICP installation"
  default     = "/dev/null"
}

variable "icp_configuration" {
  description = "Configuration items for ICP installation."
  type        = "map"
  default     = {}
}

variable "config_strategy" {
  description = "Strategy for original config.yaml shipped with ICP. Default is merge, everything else means override"
  default     = "merge"
}

variable "hooks" {
  description = "Hooks into different stages in the cluster setup process"
  type        = "map"
  default     = {}
}

variable "boot-node" {
  description = "ICP Boot node"
}

variable "install-verbosity" {
  description = "Verbosity of ansible installer output. -v to -vvvv where the maximum level includes connectivity information"
  default     = ""
}

#### Unique parameters

variable "icpuser" {
  type        = "string"
  description = "Username of initial admin user. Default: Admin"
  default     = "admin"
}

variable "icppassword" {
  type        = "string"
  description = "Password of initial admin user. Default: Admin"
  default     = "admin"
}

variable icp_source_server {
  default = ""
}

variable icp_source_user {
  default = ""
}

variable icp_source_password {
  default = ""
}

variable icp_source_path {
  default = ""
}

variable icp_source_file {
  default = ""
}

variable "install_dir" {
  default = "/opt/ibm/cluster"
}

variable "icp-arch" {
  description = "Architecture of ICP inception container. For example amd64 or ppc64le"
  default     = "amd64"
}

variable icp-ips {
  type        = "list"
  description = "Core ICP Components: Master and Worker nodes"
  default     = []
}

variable "bastion_user" {
  default = ""
}

variable "bastion_private_key" {
  default = ""
}

#Gluster Variables
variable install_gluster {
  default = false
}

variable gluster_size {
  default = 3
}

variable gluster_ips {
  default = []
}

variable gluster_svc_ips {
  default = []
}

variable device_name {
  default = "/dev/sdb"
}

variable heketi_ip {
  default = ""
}

variable heketi_svc_ip {
  default = ""
}

variable cluster_name {}

variable icp_installer_image {
  default = "ibmcom/icp-inception"
}

variable gluster_volume_type {
  default = "none"
}

variable heketi_admin_pwd {
  default = "none"
}



#locals {
#  spec-icp-ips  = "${distinct(compact(concat(list(var.boot-node), var.icp-master, var.icp-proxy, var.icp-management, var.icp-worker)))}"
#  host-group-ips = "${distinct(compact(concat(list(var.boot-node), keys(transpose(var.icp-host-groups)))))}"
#  icp-ips       = "${distinct(concat(local.spec-icp-ips, local.host-group-ips))}"
#  cluster_size  = "${length(concat(var.icp-master, var.icp-proxy, var.icp-worker, var.icp-management))}"
#  ssh_key       = "${var.ssh_key_base64 == "" ? file(coalesce(var.ssh_key_file, "/dev/null")) : base64decode(var.ssh_key_base64)}"
#  boot-node     = "${element(compact(concat(list(var.boot-node),var.icp-master)), 0)}"
#}



