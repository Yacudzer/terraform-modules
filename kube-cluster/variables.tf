variable "masters_number" {
  description = "Number of master nodes"
  default = 1
}

variable "workers_number" {
  description = "Number of workers"
  default = 1
}

variable "enveirment" {
  description = "Main prefix for server name"
  default = "adm"
}

variable "name_masters" {
  description = "Main name for master servers"
  default = "mst"
}

variable "name_workers" {
  description = "Main name for worker servers"
  default = "wrk"
}

variable "resource_pool_id" {
  description = "Resource pool id where servers will be placed"
}

variable "folder_id" {
  description = "Folder where servers will be placed"
}

variable "datastore_id" {
  description = "Datastore id for server disks"
}

variable "master_num_cpu" {
  description = "Number of cpu for masters"
  default = 2
}

variable "worker_num_cpu" {
  description = "Number of cpu for workers"
  default = 2
}

variable "master_memory" {
  description = "Memory for master nodes"
  default = 2048
}

variable "worker_memory" {
  description = "Memory for worker nodes"
  default = 2048
}

variable "network_id" {
  description = "Network id for all servers"
}

variable "thin_disk" {
  description = "Disk provisioning mode (thin or something else)"
  default = false
}

variable "add_disks_masters" {
  description = "Array with disk sizes for master nodes"
  default = []
}

variable "add_disks_workers" {
  description = "Array with disk sizes for worker nodes"
  default = []
}

variable "domain_name" {
  description = "Domain name for servers"
  default = "test.local"
}

variable "template_id" {
  description = "template id for deploy servers"
}