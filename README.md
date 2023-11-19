# Repository for common-used terraform modules
## gcp_db_postgres
Module for deploying postgres SQL server

# gcp_dns_zone
Module for creating DNS zone (private or publuc) in google cloud

## gcp_network
Simple module for gcp networks with router and NAT

## kube-cluster
Module for deploy kubernetes-cluster (just infrastructure).
Best practice for usage: template for VMs should contain at least one disk with 20Gb disk space.
You can add more disks using variables:
1. add_disks_masters
1. add_disks_workers

These variables should contain arrays for disk sizes in gigabytes. Better is using template with LVM setup and then add this disks to your logical groups.
