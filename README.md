# Tanzu Homelab

Since I [first automated my homelab setup](https://github.com/crdant/homelab), the Pivotal landscape has changed 
and we've become part of VMware. The software is still here, rebranded as Tanzu. It's also evolved to embrace 
Kubernetes, and that's where I'm most interested inn exploring. This repo is an attempt to replace my previous
automation with something focus on Tanzu, and the incorporate some of my learnings from nine months working on
a platform product team.

## Starting Point

The starting point for the automation in this repo is a two-node vSAN cluster with vSphere 7 for Kubernetes 
installed. The two nodes are Supermicro mini-1U units, one [SYS-E300-8D](https://www.supermicro.com/en/products/system/Mini-ITX/SYS-E300-8D.cfm) 
and one [SYS-E300-9D-8CN8TP](https://www.supermicro.com/en/products/system/Mini-ITX/SYS-E300-9D-8CN8TP.cfm). Both 
servers have 1TB of SSD and 4TB of spinning disk. Witness services come from a vSAN Witness Appliance running on 
vSphere 6.7u3 on a [NUC6CAYH](https://www.intel.com/content/www/us/en/products/boards-kits/nuc/kits/nuc6cayh.html). 
NSX-T is configured and Workload Management is enabled.
