# Домашнее задание к занятию "3.5. Файловые системы"

*Ссылка на ДЗ: https://github.com/netology-code/sysadm-homeworks/tree/devsys10/03-sysadmin-05-fs*

### 1. Узнайте о sparse (разряженных) файлах.

### **Ответ:**
Разряженные файлы - это такие файлы которые не позволяют 
ФС занимать свободное дисковое пространство носителя, 
когда разделы не заполнены. Пустая информация в виде нулей, будет хранится в блоке метаданных ФС. 
Поэтому, разреженные файлы изначально занимают меньший объем носителя, чем их реальный объем.


### 2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

### **Ответ:**
 Нет, они имеют одинаковые права доступа к файлу, т.к. жесткая ссылка и файл имеют один и тот же inode. Жесткая ссылка это синоним файла. inode - это индекс нода дескриптер (уникальный указатель на файл)

### 3. Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:
````
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.provider :virtualbox do |vb|
    lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
    lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
    vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
    vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
  end
  ````
Машина запущена "vagrant up"
````
D:\Vagrant\Vagrant_3>vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'bento/ubuntu-20.04'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'bento/ubuntu-20.04' version '202107.28.0' is up to date...
==> default: A newer version of the box 'bento/ubuntu-20.04' for provider 'virtualbox' is
==> default: available! You currently have version '202107.28.0'. The latest is version
==> default: '202112.19.0'. Run `vagrant box update` to update.
==> default: Setting the name of the VM: Vagrant_3_default_1640632019398_82917
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Running 'pre-boot' VM customizations...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default:
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default:
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
==> default: Mounting shared folders...
    default: /vagrant => D:/Vagrant/Vagrant_3
````

### 4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство

````
root@vagrant /h/vagrant# fdisk /dev/sdb

Command (m for help): p
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x1501ad07

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-5242879, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G

Created a new partition 1 of type 'Linux' and of size 2 GiB.

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2):
First sector (4196352-5242879, default 4196352):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879): +510M

Created a new partition 2 of type 'Linux' and of size 510 MiB.

Command (m for help): p
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x1501ad07

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5240831 1044480  510M 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
````

### 5.  Используя sfdisk, перенесите данную таблицу разделов на второй диск.

````
root@vagrant /h/vagrant# sfdisk -d /dev/sdb|sfdisk /dev/sdc
Checking that no-one is using this disk right now ... OK

The old linux_raid_member signature may remain on the device. It is recommended to wipe the device with wipefs(8) or sfdisk --wipe, in order to avoid possible collisions.

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x1501ad07.
The old linux_raid_member signature may remain on the device. It is recommended to wipe the device with wipefs(8) or sfdisk --wipe, in order to avoid possible collisions.

/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 510 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0x1501ad07

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5240831 1044480  510M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
````

### 6.  Соберите mdadm RAID1 на паре разделов 2 Гб.
````
root@vagrant /h/vagrant# mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
root@vagrant /h/vagrant# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdb2                 8:18   0  510M  0 part
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdc2                 8:34   0  510M  0 part
````

### 7. Соберите mdadm RAID0 на второй паре маленьких разделов.
````
root@vagrant /h/vagrant# mdadm --create /dev/md1 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
root@vagrant /h/vagrant# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdb2                 8:18   0  510M  0 part
  └─md1                9:1    0 1016M  0 raid0
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdc2                 8:34   0  510M  0 part
  └─md1                9:1    0 1016M  0 raid0
````
### 8. Создайте 2 независимых PV на получившихся md-устройствах.
````
root@vagrant /h/vagrant# pvcreate /dev/md1 /dev/md0
  Physical volume "/dev/md1" successfully created.
  Physical volume "/dev/md0" successfully created.
````
### 9. Создайте общую volume-group на этих двух PV.
````
root@vagrant /h/vagrant# vgcreate vg1 /dev/md1 /dev/md0
  Volume group "vg1" successfully created
root@vagrant /h/vagrant# vgdisplay
  --- Volume group ---
  VG Name               vgvagrant
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  3
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                2
  Open LV               2
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <63.50 GiB
  PE Size               4.00 MiB
  Total PE              16255
  Alloc PE / Size       16255 / <63.50 GiB
  Free  PE / Size       0 / 0
  VG UUID               PaBfZ0-3I0c-iIdl-uXKt-JL4K-f4tT-kzfcyE

  --- Volume group ---
  VG Name               vg1
  System ID
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               2.98 GiB
  PE Size               4.00 MiB
  Total PE              764
  Alloc PE / Size       0 / 0
  Free  PE / Size       764 / 2.98 GiB
  VG UUID               y1HDFw-GUNe-GX01-TKOn-DShq-0sGD-BdU9U0
````
### 10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
````
root@vagrant /h/vagrant# lvcreate -L 100M vg1 /dev/md1
  Logical volume "lvol0" created.
root@vagrant /h/vagrant# vgs
  VG        #PV #LV #SN Attr   VSize   VFree
  vg1         2   1   0 wz--n-   2.98g <2.89g
  vgvagrant   1   2   0 wz--n- <63.50g     0
root@vagrant /h/vagrant# lvs
  LV     VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lvol0  vg1       -wi-a----- 100.00m
  root   vgvagrant -wi-ao---- <62.54g
  swap_1 vgvagrant -wi-ao---- 980.00m
````
### 11. Создайте mkfs.ext4 ФС на получившемся LV.
````
root@vagrant /h/vagrant# mkfs.ext4 /dev/vg1/lvol0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
````
### 12. Смонтируйте этот раздел в любую директорию, например, /tmp/new.
````
root@vagrant /h/vagrant# mkdir /tmp/new
root@vagrant /h/vagrant# mount /dev/vg1/lvol0 /tmp/new
root@vagrant /h/vagrant# mount
....
/dev/mapper/vg1-lvol0 on /tmp/new type ext4 (rw,relatime,stripe=256)
````
### 13. Поместите туда тестовый файл, например:  
#### `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz..`
````
root@vagrant /h/vagrant# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2022-01-13 20:13:39--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 21993471 (21M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz                100%[====================================================>]  20.97M  23.4MB/s    in 0.9s

2022-01-13 20:13:40 (23.4 MB/s) - ‘/tmp/new/test.gz’ saved [21993471/21993471]

root@vagrant /h/vagrant# ls -l /tmp/new/
total 21496
drwx------ 2 root root    16384 Jan 13 20:06 lost+found/
-rw-r--r-- 1 root root 21993471 Jan 13 16:56 test.gz

````
### 14. Прикрепите вывод `lsblk`.
````
root@vagrant /h/vagrant# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdb2                 8:18   0  510M  0 part
  └─md1                9:1    0 1016M  0 raid0
    └─vg1-lvol0      253:2    0  100M  0 lvm   /tmp/new
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdc2                 8:34   0  510M  0 part
  └─md1                9:1    0 1016M  0 raid0
    └─vg1-lvol0      253:2    0  100M  0 lvm   /tmp/new
````
### 15. Протестируйте целостность файла:
````
root@vagrant /h/vagrant# gzip -t /tmp/new/test.gz
root@vagrant /h/vagrant# echo $status
0
````
### 16. Используя `pvmove`, переместите содержимое PV с RAID0 на RAID1.
````
root@vagrant /h/vagrant# pvmove /dev/md1
  /dev/md1: Moved: 8.00%
  /dev/md1: Moved: 100.00%
root@vagrant /h/vagrant# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
│   └─vg1-lvol0      253:2    0  100M  0 lvm   /tmp/new
└─sdb2                 8:18   0  510M  0 part
  └─md1                9:1    0 1016M  0 raid0
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
│   └─vg1-lvol0      253:2    0  100M  0 lvm   /tmp/new
└─sdc2                 8:34   0  510M  0 part
  └─md1                9:1    0 1016M  0 raid0
````
### 17. Сделайте --fail на устройство в вашем RAID1 md.
````
root@vagrant /h/vagrant# mdadm /dev/md0 --fail /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md0
root@vagrant /h/vagrant# mdadm -D /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Thu Jan 13 19:32:32 2022
        Raid Level : raid1
        Array Size : 2094080 (2045.00 MiB 2144.34 MB)
     Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Thu Jan 13 20:25:03 2022
             State : clean, degraded
    Active Devices : 1
   Working Devices : 1
    Failed Devices : 1
     Spare Devices : 0

Consistency Policy : resync

              Name : vagrant:0  (local to host vagrant)
              UUID : a8c8a101:e2ae9def:08219001:7f3447de
            Events : 19

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1       8       33        1      active sync   /dev/sdc1

       0       8       17        -      faulty   /dev/sdb1

````

### 18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.
````
root@vagrant /h/vagrant# dmesg |grep md0
[12275.573785] md/raid1:md0: not clean -- starting background reconstruction
[12275.573787] md/raid1:md0: active with 2 out of 2 mirrors
[12275.573799] md0: detected capacity change from 0 to 2144337920
[12275.578586] md: resync of RAID array md0
[12286.316561] md: md0: resync done.
[15425.146988] md/raid1:md0: Disk failure on sdb1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.
````
### 19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:
````
root@vagrant /h/vagrant# gzip -t /tmp/new/test.gz && echo $status
0
````
### 20. Погасите тестовый хост, vagrant destroy.
````
/drives/d/Vagrant/Vagrant_3  vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives..
````