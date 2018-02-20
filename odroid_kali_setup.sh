#!/bin/bash

mount /dev/mmcblk0p1 /boot
echo '/dev/mmcblk0p1 /boot auto defaults 0 0' >> /etc/fstab
mkdir /boot/backup
cp /boot/Image /boot/backup
cp /boot/meson64_odroidc2.dtb /boot/backup
cp /boot/uInitrd /boot/backup
touch /boot/backup/restore.sh
echo "#!/bin/bash" >> /boot/backup/restore.sh
echo "cp /boot/backup/Image /boot/" >> /boot/backup/restore.sh
echo "cp /boot/backup/meson64_odroidc2.dtb /boot/" >> /boot/backup/restore.sh
echo "cp /boot/backup/uInitrd /boot/" >> /boot/backup/restore.sh
chmod +x /boot/backup/restore.sh
/boot/backup/restore.sh

touch /etc/rc.local
echo "#!/bin/sh -e" >> /etc/rc.local
echo "/boot/backup/restore.sh" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
chmod +x /etc/rc.local
systemctl enable rc-local
service rc-local start

passwd

status=$(echo $?)

while [ $status != 0 ];do
	passwd
	status=$(echo $?)
	break
done

apt-get update && apt-get dist-upgrade
