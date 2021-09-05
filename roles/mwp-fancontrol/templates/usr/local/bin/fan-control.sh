#!/bin/bash

############################################################
#   Small script that manages fan speed on an r710
#
#   We can tie into `lm-sensors` to get core temps
#   And either average those or take the highest value
#
#   Required Variables
#   - impi_host
#   - ipmi_user
#   - ipmi_pass
#   - CPU_low   
#       - the bottom cpu threshold temp
#   - CPU_mid   
#       - midline cpu step
#       - Could add multiple tiers here, with different fan speeds
#   - CPU_high  
#       - high end cpu step
#   - CPU_danger
#       - bad cpu step
############################################################


# IPMI connection info
ipmi_host="{{ ipmi.host }}"
ipmi_user="{{ ipmi.user }}"
ipmi_pass="{{ ipmi.pass }}"

high_temp=$(sensors|grep "high"|cut -d "+" -f2|cut -d "." -f1|sort -nr|sed -n 1p)

temp_sum=0
temps=$(sensors|grep "high"|cut -d "+" -f2|cut -d "." -f1|sort -nr)
core_count=${#temps[@]}

for t in ${temps[@]}; do
    let temp_sum+=$t
done

avg_temp=$(( temp_sum / core_count ))

# Temperature Thresholds

CPU_low="{{ ipmi.temp_low }}"
CPU_mid="{{ ipmi.temp_mid }}"
CPU_high="{{ ipmi.temp_high }}"

if [ $avg_temp -le $CPU_low ] ; then

    ipmitool -I lanplus -H $ipmi_host -U $ipmi_user -P $ipmi_pass raw 0x30 0x30 0x01 0x00 >> /dev/null
    ipmitool -I lanplus -H $ipmi_host -U $ipmi_user -P $ipmi_pass raw 0x30 0x30 0x02 0xff 0x06 >> /dev/null
    # sets fan speed to silent

elif [ $avg_temp -le $CPU_mid ] ; then

    ipmitool -I lanplus -H $ipmi_host -U $ipmi_user -P $ipmi_pass raw 0x30 0x30 0x01 0x00 >> /dev/null
    ipmitool -I lanplus -H $ipmi_host -U $ipmi_user -P $ipmi_pass raw 0x30 0x30 0x02 0xff 0x12 >> /dev/null
    # sets to slight noise but higher speed

elif [ $avg_temp -le $CPU_high ] ; then

    ipmitool -I lanplus -H $ipmi_host -U $ipmi_user -P $ipmi_pass raw 0x30 0x30 0x01 0x00 >> /dev/null
    ipmitool -I lanplus -H $ipmi_host -U $ipmi_user -P $ipmi_pass raw 0x30 0x30 0x02 0xff 0x20 >> /dev/null

else

    ipmitool -I lanplus -H $ipmi_host -U $ipmi_user -P $ipmi_pass raw 0x30 0x30 0x01 0x01 >> /dev/null
    # Resets fan control to automated

fi