#!/bin/bash

arc=$(uname -a)
pcpu=$(grep "physical id" /proc/cpuinfo | sort -u | wc -l)
vcpu=$(grep -c "^processor" /proc/cpuinfo)
fram=$(free -m | awk '$1 == "Mem:" {print $2}')
uram=$(free -m | awk '$1 == "Mem:" {print $3}')
pram=$(free -m | awk '$1 == "Mem:" {printf("(%.2f%%)\n", $3/$2*100)}')
fdisk=$(df -BG --total | grep "total" | awk '{print $2}' | sed 's/G//')
udisk=$(df -BG --total | grep "total" | awk '{print $3}' | sed 's/G//')
pdisk=$(df -BG --total | grep "total" | awk '{print $5}')
cpuk=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')
lb=$(who -b | awk '{print $3, $4}')
lvmu=$(if [ $(lsblk | awk '{print $6}' | grep "lvm" | wc -l) -eq 0 ]; then echo no; else echo yes; fi)
ctcp=$(ss -t | grep ESTAB | wc -l)
ulog=$(who | wc -l)
ip=$(hostname -I | awk '{print $1}')
mac=$(ip link show | awk '/link\/ether/ {print $2}')
cmds=$(grep -c "COMMAND" /var/log/sudo/sudo.log)

wall "
#Architecture: $arc
#CPU physical: $pcpu
#vCPU: $vcpu
#Memory Usage: $uram/${fram}MB $pram
#Disk Usage: $udisk/${fdisk}GB $pdisk
#CPU load: $cpuk
#Last boot: $lb
#LVM use: $lvmu
#Connections TCP: $ctcp ESTABLISHED
#User log: $ulog
#Network: IP $ip ($mac)
#Sudo: $cmds cmd
"
