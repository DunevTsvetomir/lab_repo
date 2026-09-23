#!/usr/bin/env bash
set -euo pipefail

echo ""
echo "=== srv ready ==="
echo "LAN1: 192.168.10.10/24, gw at 192.168.10.1"
echo ""
echo "NOTE: srv's adapter 1 is VirtualBox's own NAT adapter, which Vagrant"
echo "needs for 'vagrant ssh'. By default that also gives srv its own direct"
echo "route to the internet, which is not the same as the lab's intended"
echo "'srv reaches the internet only through gw' design."
echo ""
echo "If you want to test that path strictly, run this INSIDE srv (it will"
echo "not break 'vagrant ssh', since that uses port-forwarding, not routing):"
echo ""
echo "  sudo ip route del default"
echo "  sudo ip route add default via 192.168.10.1"
echo ""
echo "This is not applied automatically so 'vagrant reload' keeps working."
