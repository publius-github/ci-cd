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
sudo systemctl stop mysql

if [ -e /data/mysql.sock ]
then
    echo "[i] DB exist, on EBS. Configure to use it with current mysql"
    sudo cp -R -p -f /var/lib/mysql/*.cnf /data
    sudo cp -R -p -f /var/lib/mysql/mysql.sock /data
else
    echo "[i] There is new EBS, copying mysql files."
    sudo cp -R -p /var/lib/mysql/* /data
fi

sudo sed -i "s/datadir=\/var\/lib\/mysql/datadir=\/data/g" /etc/my.cnf
sudo sed -i "s/socket=\/var\/lib\/mysql\/mysql.sock/socket=\/data\/mysql.sock/g" /etc/my.cnf
sudo chown -R mysql:mysql /data
sudo systemctl start mysql
