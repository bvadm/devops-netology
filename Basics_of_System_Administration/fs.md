## Домашнее задание к занятию "3.5. Файловые системы"
### 1. Узнайте о sparse (разряженных) файлах.
#### Изучил. Очень интересное решение. Подчеркнул для себя хранение образов дисков.

### 2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
#### Нет, не могут. Жёсткая ссылка на объект имеет те же права доступа, что и объекта, на который она ссылается. Это ссылка на один и тот же inode.

### 3. Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:
#### Выполнено.
    vagrant@sysadm-fs:~$ lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    loop0                       7:0    0 67.2M  1 loop /snap/lxd/21835
    loop1                       7:1    0 61.9M  1 loop /snap/core20/1328
    loop2                       7:2    0 43.6M  1 loop /snap/snapd/14978
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0  1.5G  0 part /boot
    └─sda3                      8:3    0 62.5G  0 part
    └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /
    sdb                         8:16   0  2.5G  0 disk
    sdc                         8:32   0  2.5G  0 disk

### 4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
    vagrant@sysadm-fs:~$ sudo fdisk /dev/sdb

    Welcome to fdisk (util-linux 2.34).
    Changes will remain in memory only, until you decide to write them.
    Be careful before using the write command.

    Device does not contain a recognized partition table.
    Created a new DOS disklabel with disk identifier 0x031f1de3.
    
    Command (m for help): F
    Unpartitioned space /dev/sdb: 2.51 GiB, 2683305984 bytes, 5240832 sectors
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes

    Start     End Sectors  Size
    2048 5242879 5240832  2.5G

    Command (m for help): n
    Partition type
    p   primary (0 primary, 0 extended, 4 free)
    e   extended (container for logical partitions)
    Select (default p): p
    Partition number (1-4, default 1):
    First sector (2048-5242879, default 2048):
    Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G
    Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G

    Created a new partition 1 of type 'Linux' and of size 2 GiB.

    Command (m for help): n
    Partition type
    p   primary (1 primary, 0 extended, 3 free)
    e   extended (container for logical partitions)
    Select (default p): p
    Partition number (2-4, default 2):
    First sector (4196352-5242879, default 4196352):
    Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):

    Created a new partition 2 of type 'Linux' and of size 511 MiB.

    Command (m for help): w
    The partition table has been altered.
    Calling ioctl() to re-read partition table.
    Syncing disks.

    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    └─sdb2                      8:18   0  511M  0 part

### 4. Используя sfdisk, перенесите данную таблицу разделов на второй диск.
    vagrant@sysadm-fs:~$ sudo sfdisk -d /dev/sdb | sudo sfdisk --force /dev/sdc
    Checking that no-one is using this disk right now ... OK

    Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
    Disk model: VBOX HARDDISK
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes

    >>> Script header accepted.
    >>> Script header accepted.
    >>> Script header accepted.
    >>> Script header accepted.
    >>> Created a new DOS disklabel with disk identifier 0x031f1de3.
    /dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
    /dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
    /dev/sdc3: Done.

    New situation:
    Disklabel type: dos
    Disk identifier: 0x031f1de3

    Device     Boot   Start     End Sectors  Size Id Type
    /dev/sdc1          2048 4196351 4194304    2G 83 Linux
    /dev/sdc2       4196352 5242879 1046528  511M 83 Linux

    The partition table has been altered.
    Calling ioctl() to re-read partition table.
    Syncing disks.

    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    └─sdb2                      8:18   0  511M  0 part
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    └─sdc2                      8:34   0  511M  0 part

### 6. Соберите mdadm RAID1 на паре разделов 2 Гб.
    vagrant@sysadm-fs:~$ sudo mdadm --create /dev/md1 -l 1 -n 2 /dev/sd{b1,c1}
    mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
    Continue creating array?
    Continue creating array? (y/n) y
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md1 started.

    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    │ └─md1                     9:1    0    2G  0 raid1
    └─sdb2                      8:18   0  511M  0 part
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    │ └─md1                     9:1    0    2G  0 raid1
    └─sdc2                      8:34   0  511M  0 part

### 7. Соберите mdadm RAID0 на второй паре маленьких разделов.
    vagrant@sysadm-fs:~$ sudo mdadm --create /dev/md0 -l 0 -n 2 /dev/sd{b2,c2}
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md0 started.

    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    │ └─md1                     9:1    0    2G  0 raid1
    └─sdb2                      8:18   0  511M  0 part
      └─md0                     9:0    0 1018M  0 raid0
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    │ └─md1                     9:1    0    2G  0 raid1
    └─sdc2                      8:34   0  511M  0 part
      └─md0                     9:0    0 1018M  0 raid0

### 8. Создайте 2 независимых PV на получившихся md-устройствах.
    vagrant@sysadm-fs:~$ sudo pvcreate /dev/md1 /dev/md0
    Physical volume "/dev/md1" successfully created.
    Physical volume "/dev/md0" successfully created.

    vagrant@sysadm-fs:~$ sudo pvs
    PV         VG        Fmt  Attr PSize    PFree
    /dev/md0             lvm2 ---  1018.00m 1018.00m
    /dev/md1             lvm2 ---    <2.00g   <2.00g
    /dev/sda3  ubuntu-vg lvm2 a--   <62.50g   31.25g

### 9. Создайте общую volume-group на этих двух PV.
    vagrant@sysadm-fs:~$ sudo vgcreate vg0 /dev/md0 /dev/md1
    Volume group "vg0" successfully created

    vagrant@sysadm-fs:~$ sudo vgs
    VG        #PV #LV #SN Attr   VSize   VFree
    ubuntu-vg   1   1   0 wz--n- <62.50g 31.25g
    vg0         2   0   0 wz--n-  <2.99g <2.99g

### 10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
    vagrant@sysadm-fs:~$ sudo lvcreate -L 100M vg0 /dev/md0
    Logical volume "lvol0" created.

    vagrant@sysadm-fs:~$ sudo lvs
    LV        VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
    ubuntu-lv ubuntu-vg -wi-ao---- <31.25g
    lvol0     vg0       -wi-a----- 100.00m

### 11. Создайте mkfs.ext4 ФС на получившемся LV.
    vagrant@sysadm-fs:~$ sudo mkfs.ext4 /dev/vg0/lvol0
    mke2fs 1.45.5 (07-Jan-2020)
    Creating filesystem with 25600 4k blocks and 25600 inodes

    Allocating group tables: done
    Writing inode tables: done
    Creating journal (1024 blocks): done
    Writing superblocks and filesystem accounting information: done

### 12. Смонтируйте этот раздел в любую директорию, например, /tmp/new.
    vagrant@sysadm-fs:/$ mkdir /tmp/new
    vagrant@sysadm-fs:/$ sudo mount /dev/vg0/lvol0 /tmp/new/
    
    vagrant@sysadm-fs:/$ mount | grep lvol0
    /dev/mapper/vg0-lvol0 on /tmp/new type ext4 (rw,relatime,stripe=256)

### 13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.
    vagrant@sysadm-fs:/$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
    --2022-11-12 10:37:37--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
    Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
    Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 23284079 (22M) [application/octet-stream]
    Saving to: ‘/tmp/new/test.gz’

    /tmp/new/test.gz               100%[=================================================>]  22.21M  5.13MB/s    in 4.7s

    2022-11-12 10:37:42 (4.76 MB/s) - ‘/tmp/new/test.gz’ saved [23284079/23284079]

    vagrant@sysadm-fs:/$ ls -l /tmp/new/
    total 22756
    drwx------ 2 root root    16384 Nov 12 10:32 lost+found
    -rw-r--r-- 1 root root 23284079 Nov 12 09:42 test.gz

### 14. Прикрепите вывод lsblk.
    vagrant@sysadm-fs:/$ lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    loop0                       7:0    0 67.2M  1 loop  /snap/lxd/21835
    loop1                       7:1    0 61.9M  1 loop  /snap/core20/1328
    loop2                       7:2    0 43.6M  1 loop  /snap/snapd/14978
    loop3                       7:3    0 63.2M  1 loop  /snap/core20/1695
    loop4                       7:4    0   48M  1 loop  /snap/snapd/17336
    loop5                       7:5    0 67.8M  1 loop  /snap/lxd/22753
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0  1.5G  0 part  /boot
    └─sda3                      8:3    0 62.5G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    │ └─md1                     9:1    0    2G  0 raid1
    └─sdb2                      8:18   0  511M  0 part
      └─md0                     9:0    0 1018M  0 raid0
        └─vg0-lvol0           253:1    0  100M  0 lvm   /tmp/new
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    │ └─md1                     9:1    0    2G  0 raid1
    └─sdc2                      8:34   0  511M  0 part
      └─md0                     9:0    0 1018M  0 raid0
        └─vg0-lvol0           253:1    0  100M  0 lvm   /tmp/new

### 15. Протестируйте целостность файла:
    vagrant@sysadm-fs:/$ gzip -t /tmp/new/test.gz
    vagrant@sysadm-fs:/$ echo $?
    0

### 16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
    vagrant@sysadm-fs:/$ sudo pvmove -n lvol0 /dev/md0 /dev/md1
    /dev/md0: Moved: 48.00%
    /dev/md0: Moved: 100.00%

    vagrant@sysadm-fs:/$ sudo lvs -o +devices
    LV        VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert Devices
    ubuntu-lv ubuntu-vg -wi-ao---- <31.25g                                                     /dev/sda3(0)
    lvol0     vg0       -wi-ao---- 100.00m                                                     /dev/md1(0)

### 17. Сделайте --fail на устройство в вашем RAID1 md.
    vagrant@sysadm-fs:/$ sudo mdadm --fail /dev/md1 /dev/sdb1
    mdadm: set /dev/sdb1 faulty in /dev/md1

### 18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.
    vagrant@sysadm-fs:/$ sudo dmesg | grep md1
    [ 1664.479942] md/raid1:md1: not clean -- starting background reconstruction
    [ 1664.479943] md/raid1:md1: active with 2 out of 2 mirrors
    [ 1664.479957] md1: detected capacity change from 0 to 2144337920
    [ 1664.480099] md: resync of RAID array md1
    [ 1675.008884] md: md1: resync done.
    [ 3890.969891] md/raid1:md1: Disk failure on sdb1, disabling device.
               md/raid1:md1: Operation continuing on 1 devices.

### 19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:
    vagrant@sysadm-fs:/$ gzip -t /tmp/new/test.gz
    vagrant@sysadm-fs:/$ echo $?
    0

### 20. Погасите тестовый хост, vagrant destroy.
    vagrant@sysadm-fs:/$ exit
    logout
    Connection to 127.0.0.1 closed.
    PS C:\Users\bv\vagrant_ub20_3> vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
