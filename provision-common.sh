#!/usr/bin/env bash
set -euo pipefail

# Match the "Debian_lab" credentials from the slides: user:student pass:tues
if ! id student >/dev/null 2>&1; then
  useradd -m -s /bin/bash student
  usermod -aG sudo student
fi
echo "student:tues" | chpasswd

# Passwordless sudo is convenient for lab work; drop this if you want
# students to type the password for sudo.
echo "student ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-student
chmod 440 /etc/sudoers.d/90-student

export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq iproute2 iputils-ping git iptables-persistent >/dev/null
