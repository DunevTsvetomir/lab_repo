# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Lab topology (session 1):
#   gw  : 1 vCPU, 1 GB RAM, sees WAN + LAN1 + LAN2
#   srv : 2 vCPU, 4 GB RAM, sees only LAN1
#
# Network adapters as VirtualBox/Vagrant actually create them:
#   Adapter 1 on BOTH machines = VirtualBox NAT.
#     Vagrant always needs this on adapter 1 to reach the VM for
#     `vagrant ssh` / provisioning, regardless of your topology.
#     On gw we treat it as the "WAN" link to the internet.
#     On srv it is management-only traffic (see NOTE in provision-srv.sh
#     if you want to strictly force srv's internet traffic through gw).
#   gw  Adapter 2 = intnet "lan1_net"  -> 192.168.10.1/24
#   gw  Adapter 3 = intnet "lan2_net"  -> 192.168.20.1/24
#   srv Adapter 2 = intnet "lan1_net"  -> 192.168.10.10/24

BOX = "debian/bookworm64"

Vagrant.configure("2") do |config|
  config.vm.box = BOX

  # ---------------------------------------------------------------
  # GW - gateway / router
  # ---------------------------------------------------------------
  config.vm.define "gw" do |gw|
    gw.vm.hostname = "gw"

    gw.vm.provider "virtualbox" do |vb|
      vb.name   = "gw"
      vb.memory = 1024
      vb.cpus   = 1
    end

    # Adapter 2: LAN1 (internal network, shared with srv)
    gw.vm.network "private_network",
      ip: "192.168.10.1",
      netmask: "255.255.255.0",
      virtualbox__intnet: "lan1_net",
      auto_config: true

    # Adapter 3: LAN2 (internal network, gw only)
    gw.vm.network "private_network",
      ip: "192.168.20.1",
      netmask: "255.255.255.0",
      virtualbox__intnet: "lan2_net",
      auto_config: true

    gw.vm.provision "shell", path: "provision-common.sh"
    gw.vm.provision "shell", path: "provision-gw.sh"
  end

  # ---------------------------------------------------------------
  # SRV - internal server
  # ---------------------------------------------------------------
  config.vm.define "srv" do |srv|
    srv.vm.hostname = "srv"

    srv.vm.provider "virtualbox" do |vb|
      vb.name   = "srv"
      vb.memory = 4096
      vb.cpus   = 2
    end

    # Adapter 2: LAN1 (internal network, shared with gw)
    srv.vm.network "private_network",
      ip: "192.168.10.10",
      netmask: "255.255.255.0",
      virtualbox__intnet: "lan1_net",
      auto_config: true

    srv.vm.provision "shell", path: "provision-common.sh"
    srv.vm.provision "shell", path: "provision-srv.sh"
  end
end
