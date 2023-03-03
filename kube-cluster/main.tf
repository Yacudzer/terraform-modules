locals {
  master_name_prefix    = "${var.enveirment}-${var.name_masters}-"
  worker_name_prefix    = "${var.enveirment}-${var.name_masters}-"
  master_cpu_per_socket = var.master_num_cpu < 8 ? var.master_num_cpu : (var.master_num_cpu / 2 == round(var.master_num_cpu / 2) ? var.master_num_cpu / 2 : var.master_num_cpu)
  worker_cpu_per_socket = var.worker_num_cpu < 8 ? var.worker_num_cpu : (var.worker_num_cpu / 2 == round(var.worker_num_cpu / 2) ? var.worker_num_cpu / 2 : var.worker_num_cpu)
}

resource "vsphere_virtual_machine" "k8s_masters" {
  count                  = var.masters_number
  name                   = "${local.master_name_prefix}${format("%02d", count.index + 1)}"
  resource_pool_id       = var.resource_pool_id
  folder                 = var.folder_name
  datastore_id           = var.datastore_id
  num_cpus               = var.master_num_cpu
  num_cores_per_socket   = local.worker_cpu_per_socket
  cpu_hot_add_enabled    = false
  memory                 = var.master_memory
  memory_hot_add_enabled = false
  guest_id               = "otherLinux64Guest"

  network_interface {
    network_id   = var.network_id
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "disk0"
    unit_number      = 0
    size             = "20"
    thin_provisioned = var.thin_disk
  }

  dynamic "disk" {
    for_each = var.add_disks_masters
    content {
      unit_number      = disk.key + 1
      size             = disk.value
      label            = "disk${disk.key + 1}"
      thin_provisioned = var.thin_disk
    }
  }
  clone {
    template_uuid = var.template_id
    customize {
      linux_options {
        domain    = var.domain_name
        host_name = lower("${local.master_name_prefix}${format("%02d", count.index + 1)}")
      }
      network_interface {}
    }
  }
}

resource "vsphere_virtual_machine" "k8s_workers" {
  count                  = var.workers_number
  name                   = "${local.worker_name_prefix}${format("%02d", count.index + 1)}"
  resource_pool_id       = var.resource_pool_id
  folder                 = var.folder_name
  datastore_id           = var.datastore_id
  num_cpus               = var.worker_num_cpu
  num_cores_per_socket   = local.worker_cpu_per_socket
  cpu_hot_add_enabled    = false
  memory                 = var.worker_memory
  memory_hot_add_enabled = false
  guest_id               = "otherLinux64Guest"

  network_interface {
    network_id   = var.network_id
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "disk0"
    unit_number      = 0
    size             = "20"
    thin_provisioned = var.thin_disk
  }

  dynamic "disk" {
    for_each = var.add_disks_workers
    content {
      unit_number      = disk.key + 1
      size             = disk.value
      label            = "disk${disk.key + 1}"
      thin_provisioned = var.thin_disk
    }
  }

  clone {
    template_uuid = var.template_id
    customize {
      linux_options {
        domain    = var.domain_name
        host_name = "${local.worker_name_prefix}${format("%02d", count.index + 1)}"
      }
      network_interface {}
    }
  }
}
