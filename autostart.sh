#!/bin/sh
echo "DESTROY ALL DATA ON YOUR ALL DISKS.\nARE YOU SURE?\n \nPress Enter to proceed\n\nWe Take No Responsibility Whatsoever For Any Data Loss.\n\n" > ~/tmp.txt
lsblk /dev/[vsh]d?[0-9] -l -f -p -o Name,Size,FSTYPE,LABEL | grep -v "ZERO_USB" >> tmp.txt
lsblk /dev/nvme[0-9]n[0-9]p[0-9] -l -f -p -o Name,Size,FSTYPE,LABEL | grep -v "NAME" | grep -v "ZERO_USB" >> tmp.txt
partitions=`grep ^/dev tmp.txt | cut -f 1 -d " "`

dialog --backtitle "We take no responsibility for data loss.Contact Telegram: @hbox2." \
	--yes-label "Wipe All Drives"\
	--yesno "`cat tmp.txt`" 20 60 

case "$?" in
	'0')
	for a in $partitions
	do
	size=`lsblk $a -lbfpo Size | grep -v SIZE`
	disk_var=`echo $a | cut -f 3 -d "/"`
	echo "DESTROY DATA on $a"
	dd if=/dev/zero bs=1M | pv -ept -i0.5 -w 80 -s $size -N $disk_var | dd bs=1M of=$a 
	echo "CREATE NTFS-table on $a"
	mkdir -p /media/$disk_var
	mkfs.ntfs -Q $a 
	ntfs-3g $a /media/$disk_var 
	echo "All the data on this drive $a has been wiped.\nContact Telegram: @hbox2." > /media/$disk_var/DATADESTROYED.txt
	umount /media/$disk_var
	done
	dialog --backtitle "We take no responsibility for data loss.Contact Telegram: @hbox2." \
               --ok-label "Shutdown" \
               --msgbox "All Drives Have Been Wiped.\nYour PC will be shutdown.Press Enter to Proceed." 20 60

	case "$?" in
		'0')
		echo "All data has been wiped.\n Pc will be shutdown after 10 sec.";sleep 10s;echo "Shutdown";shutdown -h now
		;;
		'1')
		echo "All data has been wiped.\n Pc will be shutdown after 10 sec.";sleep 10s;echo "Shutdown";shutdown -h now
		;;
		'255')
		echo "All data has been wiped.\n Pc will be shutdown after 10 sec.";sleep 10s;echo "Shutdown";shutdown -h now
		;;
	esac
	;;
	'1')
	echo "DESTROY CANCELING AFTER 10 sec PC will be REBOOTED.";sleep 10s;echo "REBOOT";reboot
	;;
	'255')
	echo "DESTROY CANCELING AFTER 10 sec PC will be REBOOTED.";sleep 10s;echo "REBOOT";reboot
	;;
esac

