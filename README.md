# Repository for common-used terraform modules
## kube-cluster
Module for deploy kubernetes-cluster (just infrastructure).
Best practice for usage: template for VMs should contain at least one disk with 20Gb disk space.
You can add more disks using variables:
1. add_disks_masters
1. add_disks_workers

This variables should contain array for disk sizes in gigabytes. Better is using template with LVM setup and then add this disks to your logical groups.
