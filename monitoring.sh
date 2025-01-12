#!/bin/bash
arc=$(uname -a)
pcpu=$(grep physical.id /proc/cpuinfo | sort -u | wc -l)
vcpu=$(grep processor /proc/cpuinfo | wc -l)
fram=$(free -m | awk '$1 == "Mem:" {print $2}')
uram=$(free -m | awk '$1 == "Mem:" {print $3}')
pram=$(free -m | awk '$1 == "Mem:" {printf("(%.2f%%)\n",$3/$2*100)}')
fdisk=$(df -m | grep "/dev" | grep -v "/boot" | awk '{total += $2} END {print total}')
udisk=$(df -m | grep "/dev" | grep -v "/boot" | awk '{use += $3} END {print use}')
pdisk=$(df -m | grep "/dev" | grep -v "/boot" | awk '{use += $3}{total += $2} END {printf("(%d%%)\n"), use/total*100}')
cpuk=$(vmstat 1 4 | tail -1 | awk '{print $15}')
lb=$(who -b | awk '$1== "system" {print $3 " " $4}')
lvmu=$(if [ $(lsblk |awk '{print $6}'| grep "lvm" | wc -l) -eq 0]; then echo no; else echo yes; fi)
ctcp=$(ss -ta | grep ESTAB | wc -l)
ulog=$(users | wc -w)
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')
cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)


wall "
Architecture : $arc
CPU physical : $pcpu
vCPU : $vcpu
Memory Usage : $uram/$fram MB $pram
Disk Usage : $udisk/$fdisk Gb  $pdisk
CPU load : $cpuk%
Last boot : $lb
LVM use: $lvmu
Connections TCP:$ctcp ESTABLISHED
User log: ulog
Network: IP $ip ($mac)
Sudo: $cmds cmd 
"
