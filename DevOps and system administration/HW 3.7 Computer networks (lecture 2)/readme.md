# Домашнее задание к занятию "3.7. Компьютерные сети.Лекция 2"
*Ссылка на ДЗ: https://github.com/netology-code/sysadm-homeworks/tree/devsys10/03-sysadmin-07-net*

### 1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?

### **Ответ:**
* в linux:
ip -c ad
* для windows:
ipconfig
````
root@debian11:/# ip -c a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:dd:d6:a7 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute enp0s3
       valid_lft 83094sec preferred_lft 83094sec
    inet6 fe80::a00:27ff:fedd:d6a7/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:0e:1b:47 brd ff:ff:ff:ff:ff:ff
    inet 192.168.56.101/24 brd 192.168.56.255 scope global enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe0e:1b47/64 scope link
       valid_lft forever preferred_lft forever
````
### 2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?
### **Ответ:**
* Есть три самых распространеенных вида протокола для распознавания соседа по сетевому интерфейсу:

- LLDP – протокол канального уровня для обмена информацией между соседними устройствами, позволяет определить к какому порту коммутатора подключен сервер.
- NDP (англ. Neighbor Discovery Protocol, ) - Протокол обнаружения соседей Любой компьютер, на котором установлен сетевой стек IPv6, должен выполнять NDP.  Этот протокол обнаружения используется не только для обнаружения соседних устройств, но и сетей, в которых они находятся, выбора пути, адресов DNS-серверов, шлюзов и предотвращения дублирования IP-адресов. Это довольно надежный протокол, который объединяет ARP и ICMP запросы IPv4.
- CDP (Cisco Discovery Protocol) - является собственным протоколом компании Cisco Systems, позволяющий обнаруживать подключённое (напрямую или через устройства первого уровня) сетевое оборудование Cisco, его название, версию IOS и IP-адреса
#### Какой пакет и команды есть в Linux для этого?
### **Ответ:**
- пакет lldpd. 
````
root@debian11 /home/defuser# apt-get install lldpd
root@debian11 /home/defuser# systemctl enable lldpd
root@debian11 /home/defuser# systemctl start lldpd
root@debian11 /home/defuser# lldpctl
-------------------------------------------------------------------------------
LLDP neighbors:
-------------------------------------------------------------------------------
Interface:    enp0s3, via: LLDP, RID: 1, Time: 0 day, 00:01:47
  Chassis:
    ChassisID:    mac xx:xx:xx:xx:xx:xx
    SysName:      MikroTik
    SysDescr:     MikroTik RouterOS x.xx.x (stable) CHR
    MgmtIP:       10.0.0.1
    MgmtIface:    3
    Capability:   Bridge, off
    Capability:   Router, on
  Port:
    PortID:       ifname local
    TTL:          120
````
### 3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.
### **Ответ:**
- Технология, которая используется для разделения L2 коммутатора на несколько виртуальных сетей это VLAN. Пакет - vlan. Команды - apt install vlan
- Был создан интерфейс enp0s8, на который прописали vlan 555 c ip 192.168.200.2/24, а также добавлен в автоматический запуск интерфеса при перезагрузке, с помощью строчки auto enp0s8.555
- При перезагрузке enp0s8 с vlan 555 поднялся.*

````
root@debian11 /home/defuser# cat /etc/network/interfaces
This file describes the network interfaces available on your system
and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug enp0s3
auto enp0s3
iface enp0s3 inet dhcp


# vlan с ID-555 для интерфейса enp0s8 with ID - 555
#allow-hotplug enp0s8
auto enp0s8.555
iface enp0s8.555 inet static
        address 192.168.200.2
        netmask 255.255.255.0
        vlan_raw_device enp0s8

root@debian11 /home/defuser# ping 192.168.200.2
PING 192.168.200.2 (192.168.200.2) 56(84) bytes of data.
64 bytes from 192.168.200.2: icmp_seq=1 ttl=64 time=0.034 ms
64 bytes from 192.168.200.2: icmp_seq=2 ttl=64 time=0.055 ms
^C
--- 192.168.200.2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1031ms
rtt min/avg/max/mdev = 0.034/0.044/0.055/0.010 ms

root@debian11 /home/defuser# ip -c a

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:58:0b:f2 brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.254/24 brd 10.0.0.255 scope global dynamic enp0s3
       valid_lft 557sec preferred_lft 557sec
    inet6 fe80::a00:27ff:fe58:bf2/64 scope link
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:5d:1a:cb brd ff:ff:ff:ff:ff:ff
    inet6 fe80::4f36:4c55:1d0f:b8a4/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
4: enp0s8.555@enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:5d:1a:cb brd ff:ff:ff:ff:ff:ff
    inet 192.168.200.2/24 brd 192.168.200.255 scope global enp0s8.555
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe5d:1acb/64 scope link
       valid_lft forever preferred_lft forever
````

### 4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.
### **Ответ:**
- Типы агрегации (объединения) интерфейсов в Linux

* mode=0 (balance-rr)
Этот режим используется по-умолчанию, если в настройках не указано другое. balance-rr обеспечивает балансировку нагрузки и отказоустойчивость. В данном режиме пакеты отправляются "по кругу" от первого интерфейса к последнему и сначала. Если выходит из строя один из интерфейсов, пакеты отправляются на остальные оставшиеся.При подключении портов к разным коммутаторам, требует их настройки.

* mode=1 (active-backup)
При active-backup один интерфейс работает в активном режиме, остальные в ожидающем. Если активный падает, управление передается одному из ожидающих. Не требует поддержки данной функциональности от коммутатора.

* mode=2 (balance-xor)
Передача пакетов распределяется между объединенными интерфейсами по формуле ((MAC-адрес источника) XOR (MAC-адрес получателя)) % число интерфейсов. Один и тот же интерфейс работает с определённым получателем. Режим даёт балансировку нагрузки и отказоустойчивость.

* mode=3 (broadcast)
Происходит передача во все объединенные интерфейсы, обеспечивая отказоустойчивость.

* mode=4 (802.3ad)
Это динамическое объединение портов. В данном режиме можно получить значительное увеличение пропускной способности как входящего так и исходящего трафика, используя все объединенные интерфейсы. Требует поддержки режима от коммутатора, а так же (иногда) дополнительную настройку коммутатора.

* mode=5 (balance-tlb)
Адаптивная балансировка нагрузки. При balance-tlb входящий трафик получается только активным интерфейсом, исходящий - распределяется в зависимости от текущей загрузки каждого интерфейса. Обеспечивается отказоустойчивость и распределение нагрузки исходящего трафика. Не требует специальной поддержки коммутатора.

* mode=6 (balance-alb)
Адаптивная балансировка нагрузки (более совершенная). Обеспечивает балансировку нагрузки как исходящего (TLB, transmit load balancing), так и входящего трафика (для IPv4 через ARP). Не требует специальной поддержки коммутатором, но требует возможности изменять MAC-адрес устройства.

```
root@debian11:/home/def_user# nano /etc/network/interfaces
source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

auto enp0s8
iface enp0s8 inet static
address 192.168.56.101
netmask 255.255.255.0

auto enp0s6
iface enp0s6 inet dhcp

auto enp0s7
iface enp0s7 inet dhcp

# The primary network interface
auto bond0 enp0s6 enp0s7
iface bond0 inet static
        address 10.0.0.11
        netmask 255.255.255.0
        gateway 10.0.0.254
        bond-slaves enp0s6 enp0s7
        bond-mode balance-alb
bond-miimon 100
bond-downdelay 200
        bond-updelay 200
```
### 5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.
### **Ответ:**
*8 ip адресов находится внутри /29. Из маски /24 можно получить 32 сети с маской /29*

### 6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.
### **Ответ:**
*Адресный блок 100.64.0.0/26 - подойдет для организации стыка между двумя организациями из расчета 40-50 хостов, т.к. содержит в себе максимально возможные 64 ip, из которых два зарезервированы под адрес сети и broadkast.*

### 7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?
### **Ответ:**

в linux:
```
root@debian11:/# arp -e
Address                  HWtype  HWaddress           Flags Mask            Iface
192.168.56.1             ether   xx:xx:xx:xx:xx:xx   C                     enp0s8
_gateway                 ether   xx:xx:xx:xx:xx:xx   C                     enp0s3
```

в windows:

```
arp -a

Интерфейс: 192.168.56.1 --- 0xa
  адрес в Интернете      Физический адрес      Тип
  192.168.56.101         xx-xx-xx-xx-xx-xx     динамический
  192.168.56.255         xx-xx-xx-xx-xx-xx     статический
  
  Для удаления ip адреса из ARP таблицы в ОС windows и Linux используется команда   arp -d [ip-адрес]
  Для очистки ARP-кеш в  windows netsh interface ip delete arpcache
  Для очистки ARP-кеш в  linux ip -s -s neigh flush all [dev<device>]
```