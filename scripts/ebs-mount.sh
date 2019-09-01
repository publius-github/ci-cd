#!/bin/bash
fs=$(sudo file -s /dev/xvdh | grep filesystem -c)
if [ $fs -eq "1" ]
then
    echo "[i] FS is exist."
else
    echo "[i] Creating filesystem..."
    sudo mkfs -t xfs /dev/xvdh
fi
sudo mkdir -p /data
sudo chmod 755 /data
sudo mount /dev/xvdh /data

uid=$(sudo blkid | sed -n '/xvdh/s/.*UUID=\"\([^\"]*\)\".*/\1/p')
echo "UUID=$uid  /data  xfs  defaults,nofail  0  2" | sudo tee --append /etc/fstab > /dev/null
