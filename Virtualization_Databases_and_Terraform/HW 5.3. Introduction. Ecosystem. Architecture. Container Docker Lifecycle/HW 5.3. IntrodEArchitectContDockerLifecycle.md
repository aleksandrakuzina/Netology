### Задача 1 

> Сценарий выполения задачи:

    создайте свой репозиторий на https://hub.docker.com;
    выберете любой образ, который содержит веб-сервер Nginx;
    создайте свой fork образа;
    реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:

````
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
````

интерфейсы на моей машине
````
root@debian .../lib/docker# ip -c a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:d4:48:4a brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.226/24 brd 192.168.0.255 scope global enp0s3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fed4:484a/64 scope link
       valid_lft forever preferred_lft forever
3: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 0a:64:28:5e:96:d8 brd ff:ff:ff:ff:ff:ff
    inet 10.2.2.2/32 brd 10.2.2.2 scope global dummy0
       valid_lft forever preferred_lft forever
    inet6 fe80::864:28ff:fe5e:96d8/64 scope link
       valid_lft forever preferred_lft forever
4: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:62:97:fb:96 brd ff:ff:ff:ff:ff:ff
    inet 172.18.0.1/16 brd 172.18.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:62ff:fe97:fb96/64 scope link
       valid_lft forever preferred_lft forever
22: veth4b58524@if21: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP group default
    link/ether e2:c2:05:69:1c:84 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::e0c2:5ff:fe69:1c84/64 scope link
       valid_lft forever preferred_lft forever

````
образы docker на моей машине
````
root@debian .../lib/docker# docker images
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
nginx         latest    c316d5a335a5   3 weeks ago    142MB
hello-world   latest    feb5d9fea6a5   4 months ago   13.3kB
````
переход внутрь контейнера
````
root@debian .../lib/docker# docker exec -it trusting_shaw bash
root@68b936262240:/# echo '<html><head>Hey, Netology</head><body><h1>I am DevOps Engineer!</h1></body></html>' > /usr/share/nginx/html/index.html
````
запущенные контейнеры на моей машине
````
root@debian .../lib/docker# docker ps -a
CONTAINER ID   IMAGE     COMMAND                  CREATED             STATUS                       PORTS     NAMES
68b936262240   nginx     "/docker-entrypoint.…"   8 minutes ago       Exited (0) 5 minutes ago               trusting_shaw
```` 
проброс порта с виртуальной машины (8080) nginx (80)
````
root@debian .../lib/docker# docker run -p 8080:80 -it nginx bash
root@68b936262240:/# ls -l
total 72
drwxr-xr-x   2 root root 4096 Jan 25 00:00 bin
drwxr-xr-x   2 root root 4096 Dec 11 17:25 boot
drwxr-xr-x   5 root root  360 Feb 18 13:46 dev
drwxr-xr-x   1 root root 4096 Jan 26 08:58 docker-entrypoint.d
-rwxrwxr-x   1 root root 1202 Jan 26 08:58 docker-entrypoint.sh
drwxr-xr-x   1 root root 4096 Feb 18 13:46 etc
drwxr-xr-x   2 root root 4096 Dec 11 17:25 home
drwxr-xr-x   1 root root 4096 Jan 25 00:00 lib
drwxr-xr-x   2 root root 4096 Jan 25 00:00 lib64
drwxr-xr-x   2 root root 4096 Jan 25 00:00 media
drwxr-xr-x   2 root root 4096 Jan 25 00:00 mnt
drwxr-xr-x   2 root root 4096 Jan 25 00:00 opt
dr-xr-xr-x 142 root root    0 Feb 18 13:46 proc
drwx------   2 root root 4096 Jan 25 00:00 root
drwxr-xr-x   3 root root 4096 Jan 25 00:00 run
drwxr-xr-x   2 root root 4096 Jan 25 00:00 sbin
drwxr-xr-x   2 root root 4096 Jan 25 00:00 srv
dr-xr-xr-x  13 root root    0 Feb 18 13:05 sys
drwxrwxrwt   1 root root 4096 Jan 26 08:58 tmp
drwxr-xr-x   1 root root 4096 Jan 25 00:00 usr
drwxr-xr-x   1 root root 4096 Jan 25 00:00 var
````

 ![Alt text](2022-02-18_170755.png)


### Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос: "Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

>   Высоконагруженное монолитное java веб-приложение;
>   Физический сервер, т.к. монолитное (доставляемое через единую систему развертывания с одной точкой входа), потому в микросерверах не реализуемо без изменения кода,
   и так как высоконагруженное (необходим физический доступ к ресурсам, виртуалка не подходит).

>   Nodejs веб-приложение; 
>   Docker, и в рамках микропроцессрной архитектуры может быть хорошим решением.

>   Мобильное приложение c версиями для Android и iOS;
>   Виртуальная машина - приложение в докере не имеет графической оболочки

>   Шина данных на базе Apache Kafka; 
>   Виртуальная машина - для продакшена и критичности данных (если потеря данных при потере контейнера не является критичной - можно использовать контейнеры), 
   Docker - для тестирования.

>   Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
>   Виртуальная машина - Elasticsearvh, отказоустойчивость решается на уровне кластера, 
   Docker - logstash и kibana.

>   Мониторинг-стек на базе Prometheus и Grafana;
>   Docker - системы не хранят данных.

>   MongoDB, как основное хранилище данных для java-приложения;
>   Виртуальная машина - посольку это хранилище, не высоконагруженное.
   физический сервер не подходит под базу данных, т. к. затратно.

>   Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
>   Docker-контейнеризация.

### Задание 3 


    * Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера;
    * Запустите второй контейнер из образа debian в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера;
    * Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data;
    * Добавьте еще один файл в папку /data на хостовой машине;
    * Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.


Создаем образ debian centos
```
root@debian11:/home/def_user# docker images
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
debian        latest    d40157244907   11 days ago    124MB
hello-world   latest    feb5d9fea6a5   5 months ago   13.3kB
centos        latest    5d0da3dc9764   5 months ago   231MB
```

Создаем папку /data на хостовой машине
```
root@debian11:/home/def_user# mkdir /data
root@debian11:/home/def_user# ls -l / | grep data
drwxr-xr-x   2 root     root      4096 мар 12 17:26 data
```

Монтируем папку /data на хостовой машине в создаваемые контенейры из существующих образов
```
root@debian11:/# docker run --name Centos -v /data:/data:rw centos
root@debian11:/# docker run --name Debian -v /data:/data:rw debian
root@debian11:/# docker ps -a
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS                      PORTS     NAMES
aab8de75f1d7   debian    "bash"        6 seconds ago    Exited (0) 4 seconds ago              Debian
6609b067db8d   centos    "/bin/bash"   32 seconds ago   Exited (0) 31 seconds ago             Centos
```

Подключаемся к первому контейнеру с помощью docker exec и создаем текстовый файл любого содержания в /data
```
root@debian11:/# docker exec -it Debian touch /data/test_file
root@debian11:/# docker attach Debian
root@aab8de75f1d7:/# ls -l data/
total 0
-rw-r--r-- 1 root root 0 Mar 12 15:14 test_file
```

Создаем файл в папке /data на хостовой машине
```
root@debian11:/data# touch hello_from_host_machine
root@debian11:/data# ls -l
итого 0
-rw-r--r-- 1 root root 0 мар 12 18:19 hello_from_host_machine
-rw-r--r-- 1 root root 0 мар 12 18:14 test_file
```

Выводим листинг во втором контейнере
```
root@debian11:/home/def_user# docker attach Centos
[root@6609b067db8d /]# ls -l /data
total 0
-rw-r--r-- 1 root root 0 Mar 12 15:19 hello_from_host_machine
-rw-r--r-- 1 root root 0 Mar 12 15:14 test_file
```
