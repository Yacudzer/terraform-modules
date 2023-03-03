output "masters_names" {
  value = vsphere_virtual_machine.k8s_masters[*].name
}

output "masters_ip" {
  value = vsphere_virtual_machine.k8s_masters[*].default_ip_address
}

output "workers_name" {
  value = vsphere_virtual_machine.k8s_workers[*].name
}

output "workers_ip" {
  value = vsphere_virtual_machine.k8s_workers[*].default_ip_address
}

output "masters_full" {
  value = [
    for vm in vsphere_virtual_machine.k8s_masters :
    {
      hostname : vm.name
      ip : vm.default_ip_address
    }
  ]
}

output "workers_full" {
  value = [
    for vm in vsphere_virtual_machine.k8s_workers :
    {
      hostname : vm.name
      ip : vm.default_ip_address
    }
  ]
}
