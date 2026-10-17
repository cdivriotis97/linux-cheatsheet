#!/bin/bash

TYPE=$(hostnamectl | awk '/Chassis:/ {print $NF}')
NOACTION=""

while getopts "lndv" c ; do
   save=$OPTIND
        case $c in
        l|n)      NOACTION="DISPLAY" ;;
        d|v)      set -x ;;
        \?)     echo $USAGE; exit 1 ;;
        esac
   OPTIND=$save
done

if  [ -z "$NOACTION" ] ; then

if [ "$TYPE" = "server" ] ;  then
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/storage_administration_guide/adding_storage-device-or-path

# https://access.redhat.com/discussions/1455393
for BUS in /sys/class/scsi_host/host*/scan
do
echo "echo \"- - -\" >  ${BUS}"
   echo "- - -" >  ${BUS}
done
fi

if command -v multipath >/dev/null 2>&1; then
    mapfile -t WWIDS < <(multipath -ll | awk '/^mpath/ {print $2}' | tr -d '[]')
    for WWID in "${WWIDS[@]}"; do
        multipathd "resize map $WWID"
        kpartx -u "/dev/mapper/$WWID"
    done
fi

pvscan ;

lsblk   -o KNAME,TYPE,FSTYPE,PKNAME | awk '$3 == "LVM2_member" && $2  == "part" { print $4 } ; $3 == "LVM2_member" && $2  == "disk" { print $1 } ;' | xargs -r -n1 printf "echo 1 > /sys/block/%s/device/rescan\n" |bash

partprobe
lvmdiskscan
pvdisplay

pvdisplay -c | awk -F: '{print $1}' | while read pv ; do
disk=${pv%[0-9]}
num=${pv#$disk}
fdisk -l $disk
test -n "$num" && test "$num" -ge 1 && growpart $disk $num
grep sd /proc/partitions
pvresize $pv
done

lvmdiskscan

fi

vgdisplay -s

echo "# Now Run somethins like"
VG=$(lvs |awk '$1 == "root" {print $2}')
VGMAP=$(df -k / | awk 'NR>1 {print $1}' | xargs -I{} -n1 basename {} -root)
lvs $VG -o name --noheadings | grep -v swap | xargs -n1 -I{}  echo "lvresize -r -L +30G /dev/mapper/${VGMAP}-"{}
