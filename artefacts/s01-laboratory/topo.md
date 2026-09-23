Топология – Сесия 1

Машини:

gw: vCPU: 1; RAM: 1 GB; WAN (NAT), LAN1 (192.168.10.1/24), LAN2 (192.168.20.1/24)
srv: vCPU: 2; RAM: 4 GB; LAN1 (192.168.10.10/24)                     |

Потребител на двете машини: `student` / `tues`

Сегменти:

- WAN - VirtualBox NAT адаптер на 'gw' (adapter 1), достъп до интернет.
- LAN1 - VirtualBox internal network 'lan1_net', между 'gw' (192.168.10.1)
  и 'srv' (192.168.10.10).
- LAN2 - VirtualBox internal network 'lan2_net', само на 'gw'
  (192.168.20.1), без друга машина в момента.