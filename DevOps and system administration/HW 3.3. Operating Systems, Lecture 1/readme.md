### 1. Какой системный вызов делает команда cd? В прошлом ДЗ мы выяснили, что cd не является самостоятельной программой, это shell builtin, поэтому запустить strace непосредственно на cd не получится.Тем не менее, вы можете запустить strace на /bin/bash -c 'cd /tmp'. В этом случае вы увидите полный список системных вызовов, которые делает сам bash при старте. Вам нужно найти тот единственный, который относится именно к cd. Обратите внимание, что strace выдаёт результат своей работы в поток stderr, а не в stdout.*

Уточнения по первому заданию:

*Перенаправила поток stderr в stdout (пример ниже)*

*Именно к cd относится следующий вызов: chdir("/tmp")*

````
root@vagrant:~# strace /bin/bash -c 'cd /tmp' 2>error
root@vagrant:~# cat error

execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffd1d8c74f0 /* 20 vars */) = 0
brk(NULL)                               = 0x55ecf31e2000
arch_prctl(0x3001 /* ARCH_??? */, 0x7fff64b59e60) = -1 EINVAL (Invalid argument)
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=23886, ...}) = 0
mmap(NULL, 23886, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7ffa8b616000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libtinfo.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\240\346\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=192032, ...}) = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ffa8b614000
mmap(NULL, 194944, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7ffa8b5e4000
mmap(0x7ffa8b5f2000, 61440, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xe000) = 0x7ffa8b5f2000
mmap(0x7ffa8b601000, 57344, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1d000) = 0x7ffa8b601000
mmap(0x7ffa8b60f000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2a000) = 0x7ffa8b60f000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libdl.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0 \22\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=18816, ...}) = 0
mmap(NULL, 20752, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7ffa8b5de000
mmap(0x7ffa8b5df000, 8192, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1000) = 0x7ffa8b5df000
mmap(0x7ffa8b5e1000, 4096, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7ffa8b5e1000
mmap(0x7ffa8b5e2000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7ffa8b5e2000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\360q\2\0\0\0\0\0"..., 832) = 832
pread64(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"..., 784, 64) = 784
pread64(3, "\4\0\0\0\20\0\0\0\5\0\0\0GNU\0\2\0\0\300\4\0\0\0\3\0\0\0\0\0\0\0", 32, 848) = 32
pread64(3, "\4\0\0\0\24\0\0\0\3\0\0\0GNU\0\t\233\222%\274\260\320\31\331\326\10\204\276X>\263"..., 68, 880) = 68
fstat(3, {st_mode=S_IFREG|0755, st_size=2029224, ...}) = 0
pread64(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"..., 784, 64) = 784
pread64(3, "\4\0\0\0\20\0\0\0\5\0\0\0GNU\0\2\0\0\300\4\0\0\0\3\0\0\0\0\0\0\0", 32, 848) = 32
pread64(3, "\4\0\0\0\24\0\0\0\3\0\0\0GNU\0\t\233\222%\274\260\320\31\331\326\10\204\276X>\263"..., 68, 880) = 68
mmap(NULL, 2036952, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7ffa8b3ec000
mprotect(0x7ffa8b411000, 1847296, PROT_NONE) = 0
mmap(0x7ffa8b411000, 1540096, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x25000) = 0x7ffa8b411000
mmap(0x7ffa8b589000, 303104, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x19d000) = 0x7ffa8b589000
mmap(0x7ffa8b5d4000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1e7000) = 0x7ffa8b5d4000
mmap(0x7ffa8b5da000, 13528, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7ffa8b5da000
close(3)                                = 0
mmap(NULL, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ffa8b3e9000
arch_prctl(ARCH_SET_FS, 0x7ffa8b3e9740) = 0
mprotect(0x7ffa8b5d4000, 12288, PROT_READ) = 0
mprotect(0x7ffa8b5e2000, 4096, PROT_READ) = 0
mprotect(0x7ffa8b60f000, 16384, PROT_READ) = 0
mprotect(0x55ecf2413000, 16384, PROT_READ) = 0
mprotect(0x7ffa8b649000, 4096, PROT_READ) = 0
munmap(0x7ffa8b616000, 23886)           = 0
openat(AT_FDCWD, "/dev/tty", O_RDWR|O_NONBLOCK) = 3
close(3)                                = 0
brk(NULL)                               = 0x55ecf31e2000
brk(0x55ecf3203000)                     = 0x55ecf3203000
openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=5699248, ...}) = 0
mmap(NULL, 5699248, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7ffa8ae79000
close(3)                                = 0
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=27002, ...}) = 0
mmap(NULL, 27002, PROT_READ, MAP_SHARED, 3, 0) = 0x7ffa8ae72000
close(3)                                = 0
getuid()                                = 0
getgid()                                = 0
geteuid()                               = 0
getegid()                               = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
ioctl(-1, TIOCGPGRP, 0x7fff64b59cb4)    = -1 EBADF (Bad file descriptor)
sysinfo({uptime=11665, loads=[0, 0, 0], totalram=1028694016, freeram=356265984, sharedram=716800, bufferram=22196224, totalswap=1027600384, freeswap=1027600384, procs=139, totalhigh=0, freehigh=0, mem_unit=1}) = 0
rt_sigaction(SIGCHLD, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER|SA_RESTART, sa_restorer=0x7ffa8b432210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGCHLD, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER|SA_RESTART, sa_restorer=0x7ffa8b432210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER|SA_RESTART, sa_restorer=0x7ffa8b432210}, 8) = 0
rt_sigaction(SIGINT, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7ffa8b432210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGINT, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7ffa8b432210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7ffa8b432210}, 8) = 0
rt_sigaction(SIGQUIT, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7ffa8b432210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGQUIT, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7ffa8b432210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7ffa8b432210}, 8) = 0
rt_sigaction(SIGTSTP, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7ffa8b432210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGTSTP, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7ffa8b432210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7ffa8b432210}, 8) = 0
rt_sigaction(SIGTTIN, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7ffa8b432210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGTTIN, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7ffa8b432210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7ffa8b432210}, 8) = 0
rt_sigaction(SIGTTOU, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7ffa8b432210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGTTOU, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7ffa8b432210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7ffa8b432210}, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigaction(SIGQUIT, {sa_handler=SIG_IGN, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7ffa8b432210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7ffa8b432210}, 8) = 0
uname({sysname="Linux", nodename="vagrant", ...}) = 0
stat("/root", {st_mode=S_IFDIR|0700, st_size=4096, ...}) = 0
stat(".", {st_mode=S_IFDIR|0700, st_size=4096, ...}) = 0
stat("/root", {st_mode=S_IFDIR|0700, st_size=4096, ...}) = 0
getpid()                                = 13489
getppid()                               = 13486
getpid()                                = 13489
getpgrp()                               = 13486
ioctl(2, TIOCGPGRP, 0x7fff64b59b74)     = -1 ENOTTY (Inappropriate ioctl for device)
rt_sigaction(SIGCHLD, {sa_handler=0x55ecf2359aa0, sa_mask=[], sa_flags=SA_RESTORER|SA_RESTART, sa_restorer=0x7ffa8b432210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER|SA_RESTART, sa_restorer=0x7ffa8b432210}, 8) = 0
ioctl(2, TIOCGPGRP, 0x7fff64b59b54)     = -1 ENOTTY (Inappropriate ioctl for device)
prlimit64(0, RLIMIT_NPROC, NULL, {rlim_cur=3571, rlim_max=3571}) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
getpeername(0, 0x7fff64b59cb0, [16])    = -1 ENOTSOCK (Socket operation on non-socket)
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0
chdir("/tmp")                           = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
exit_group(0)                           = ?
+++ exited with 0 +++
````

### Какой системный вызов делает команда cd?
*Change Directory*

*Выполнив команду /bin/bash -c 'cd /tmp' получила полный список системных вызовов (часть резутата вывода команды ниже) из которого наблюдается вывод Chdir (она же "cd") которая подразумевает переход в каталог /tmp*

### Обратите внимание, что strace выдаёт результат своей работы в поток stderr, а не в stdout.

*если выдает в stderr значит видимо нам надо наблюдать за кодом ошибки ENOET (файл,сценарий или интерпретатор ELF не существует,
или не найдена динамическая библиотека, необходимая для файлового интерпретатора)*

```
execve("cd/tmp", ["cd/tmp"], 0x55ab764d11e0 / 22 vars /) = -1 ENOENT (No such file or directory)
stat("cd/tmp", 0x7ffea45297f0)          = -1 ENOENT (No such file or directory)
stat("cd/tmp", 0x7ffea45297d0)          = -1 ENOENT (No such file or directory)
```

### 2. Попробуйте использовать команду file на объекты разных типов на файловой системе.

Например:

vagrant@netology1 :~ $ file /dev/tty
/dev/tty: character special (5/0)
vagrant@netology1: ~ $ file /dev/sda
/dev/sda: block special (8/0)
vagrant@netology1:~ $ file /bin/bash
/bin/bash: ELF 64-bit LSB shared object, x86-64

### Используя strace выясните, где находится база данных file на основании которой она делает свои догадки.**

*из справочника по утилитам:
"...Команда file позволяет определить тип файла посредством проверки соответствия начальных
символов файла определенному "магическому" числу (помимо прочих проверок).
В файле /usr/share/misc/magic указаны "магические" числа для проверки, сообщение, которое
будет выведено в случае обнаружения конкретного "магического" числа, а также дополнительная
информация, извлекаемая из файла..."*

````
stat("/root/.magic.mgc", 0x7fff8f4523d0) = -1 ENOENT (No such file or directory)
stat("/root/.magic", 0x7fff8f4523d0)    = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
stat("/etc/magic", {st_mode=S_IFREG|0644, st_size=111, ...}) = 0
openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=111, ...}) = 0
read(3, "# Magic local data for file(1) c"..., 4096) = 111
read(3, "", 4096)                       = 0
close(3)                                = 0
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=4961856, ...}) = 0
````

### 3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается.Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

1. Дескриптор верный 14215 обнуляю его
2. c помощью df увидела, что место на диске не меняется, вероятно что файл обнулился

``````
root@vagrant:/home/vagrant#echo ping 8.8.8.8 > FILE_LOG
root@vagrant:/home/vagrant# ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root       14215  0.0  0.0   9692   936 pts/0    S+   20:22   0:00 ping 8.8.8.8

root@vagrant:/home/vagrant# ps -ef | grep 8.8.8.8
root       14215   14159  0 20:22 pts/0    00:00:00 ping 8.8.8.8

root@vagrant:/home/vagrant# lsof -p 14215
COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF   NODE NAME
ping    14215 root    1w   REG  253,0    19537 137537 /home/vagrant/FILE_LOG

root@vagrant:/home/vagrant# rm FILE_LOG

root@vagrant:/home/vagrant# lsof -p 14215
COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF   NODE NAME
ping    14215 root    1w   REG  253,0    37793 137537 /home/vagrant/FILE_LOG (deleted)

root@vagrant:/home/vagrant# echo '' >/proc/14215/fd/1
root@vagrant:/home/vagrant# cat /dev/null > /proc/14215/fd/1
root@vagrant:/home/vagrant# :> /proc/14215/fd/1
root@vagrant:/home/vagrant# > /proc/14215/fd/1
root@vagrant:/home/vagrant# truncate -s 0 /proc/14215/fd/1

root@vagrant:/home/vagrant# lsof -p 14215
COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF   NODE NAME
ping    14215 root    1w   REG  253,0    66369 137537 /home/vagrant/FILE_LOG (deleted)


Место на диске не меняется, значит видимо обнулила
root@vagrant:/home/vagrant# df
Filesystem                 1K-blocks    Used Available Use% Mounted on
udev                          457128       0    457128   0% /dev
tmpfs                         100460     720     99740   1% /run
/dev/mapper/vgvagrant-root  64284292 1719664  59269396   3% /
tmpfs                         502292       0    502292   0% /dev/shm
tmpfs                           5120       0      5120   0% /run/lock
tmpfs                         502292       0    502292   0% /sys/fs/cgroup
/dev/sda1                     523248       4    523244   1% /boot/efi
tmpfs                         100456       0    100456   0% /run/user/1000

root@vagrant:/home/vagrant# ls -l
total 0
-rw-r--r-- 1 root root 0 Jan  9 07:20 1063
-rw-r--r-- 1 root root 0 Jan 11 20:49 FILE_LOGG
``````


### 4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?**

"Зомби" процессы, в отличии от "сирот" освобождают свои ресурсы, но не освобождают запись в таблице процессов.

### 5. В iovisor BCC есть утилита opensnoop: root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop /usr/sbin/opensnoop-bpfcc На какие файлы вы увидели вызовы группы open за первую секунду работы утилиты? Воспользуйтесь пакетом bpfcc-tools для Ubuntu 20.04. Дополнительные сведения по установке.

*За первые секунды работы утилиты наблюдаются вызовы к следующим файлам: utmp (Этот файл содержит информацию о пользователях, которые в настоящее время вошли в систему), а например через систему dbus-daemon (система межпроцессного взаимодействия, которая позволяет приложениям в операционной системе сообщаться друг с другом) лежит путь /usr/local/share/dbus-1/system-services это стандартный директорий для установки файлов.service.

````
root@vagrant:/home/vagrant# dpkg -L bpfcc-tools | grep sbin/opensnoop
/usr/sbin/opensnoop-bpfcc
root@vagrant:/home/vagrant# /usr/sbin/opensnoop-bpfcc
PID    COMM               FD ERR PATH
887    vminfo              6   0 /var/run/utmp
688    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
688    dbus-daemon        19   0 /usr/share/dbus-1/system-services
688    dbus-daemon        -1   2 /lib/dbus-1/system-services
688    dbus-daemon        19   0 /var/lib/snapd/dbus-1/system-services/
423    systemd-udevd      14   0 /sys/fs/cgroup/unified/system.slice/systemd-udevd.service/cgroup.procs
423    systemd-udevd      14   0 /sys/fs/cgroup/unified/system.slice/systemd-udevd.service/cgroup.threads

````

### 6.Какой системный вызов использует uname -a? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в /proc, где можно узнать версию ядра и релиз ОС.

*uname -a представляет вызов результата всех ключей all (-a) по которым предоставляется информация о названии ядра системы, версии, релизе ядра системы, типе операционной системы*

*Альтернативное местоположение системого вызова находится: / proc / sys / ядро/ {osrelease, version}*

### 7.Чем отличается последовательность команд через ";" и через "&&" в bash? Например**: root@netology1:~ # test -d /tmp/some_dir; echo Hi root@netology1: ~ # test -d /tmp/some_dir && echo Hi root@netology1: ~ # Есть ли смысл использовать в bash &&, если применить set -e?

*Разница в том, что при исполнении команд через ";" они исполняются последовательно и следующая команда исполнится в любом случае в не зависимости от успешного /неуспешного завершения предыдущей.*

*При исполнении команд через "&&" каждая последующая команда будет исполняться только в случае успешного завершения предыдущей.
Kоманда set -e прерывает процесс исполнения программы, даже если оболочка возвращает ненулевой статус
имеет смысл, если исполнится вместе через ";"*

### 8.Из каких опций состоит режим bash set -euxo pipefail и почему его хорошо было бы использовать в сценариях?

````
-e прерывает выполнение исполнения при ошибке любой команды кроме последней в последовательности 
-x вывод трейса простых команд 
-u неустановленные/не заданные параметры и переменные считаются как ошибки, с выводом в stderr текста ошибки и выполнит завершение неинтерактивного вызова
-o pipefail возвращает код возврата набора/последовательности команд, ненулевой при последней команды или 0 для успешного выполнения команд.
````

*Для сценария хорошо тем, что отслеживает ошибки и прерывает исполнение сценария при ошибке любой команды кроме последней*

### 9.Используя -o stat для ps, определите, какой наиболее часто встречающийся статус у процессов в системе. В man ps ознакомьтесь (/PROCESS STATE CODES) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными)**

*Верно ли понимаю, что у меня самые частые процессы в системе узнаем по команде "ps -o stat" :*

````
vagrant@ubuntu2:~$ ps -o stat
STAT
Ss - спящий процесс в лидирующей сессии
Ssl -спящий процесс с низким  в лидирующей сессии
S - спящий процесс
I - фоновые процессы ядра
I< - фоновые процессы ядра с высокимм приоритетом
R+ -  выполняемый процесс, который находится в основной группе процессов
SN - спящий с низким приоритетом
````

````
PROCESS STATE CODES
Here are the different values that the s, stat and state output specifiers (header "STAT" or "S") will display to describe the state of a process:

D    uninterruptible sleep (usually IO)
R    running or runnable (on run queue)
S    interruptible sleep (waiting for an event to complete)
T    stopped by job control signal
t    stopped by debugger during the tracing
W    paging (not valid since the 2.6.xx kernel)
X    dead (should never be seen)
Z    defunct ("zombie") process, terminated but not reaped by its parent

<    high-priority (not nice to other users)
N    low-priority (nice to other users)
L    has pages locked into memory (for real-time and custom IO)
s    is a session leader
l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
+    is in the foreground process group
````

````
все статусы в системе:

vagrant@ubuntu2:~$ ps -ax
  PID TTY      STAT   TIME COMMAND
    1 ?        Ss     0:00 /sbin/init
    2 ?        S      0:00 [kthreadd]
    4 ?        I<     0:00 [kworker/0:0H]
    6 ?        I<     0:00 [mm_percpu_wq]
    7 ?        S      0:00 [ksoftirqd/0]
    8 ?        I      0:00 [rcu_sched]
    9 ?        I      0:00 [rcu_bh]
   10 ?        S      0:00 [migration/0]
   11 ?        S      0:00 [watchdog/0]
   12 ?        S      0:00 [cpuhp/0]
   13 ?        S      0:00 [kdevtmpfs]
   14 ?        I<     0:00 [netns]
   15 ?        S      0:00 [rcu_tasks_kthre]
   16 ?        S      0:00 [kauditd]
   17 ?        S      0:00 [khungtaskd]
   18 ?        S      0:00 [oom_reaper]
   19 ?        I<     0:00 [writeback]
   20 ?        S      0:00 [kcompactd0]
   21 ?        SN     0:00 [ksmd]
   22 ?        SN     0:00 [khugepaged]
   23 ?        I<     0:00 [crypto]
   24 ?        I<     0:00 [kintegrityd]
   25 ?        I<     0:00 [kblockd]
   26 ?        I<     0:00 [ata_sff]
   27 ?        I<     0:00 [md]
   28 ?        I<     0:00 [edac-poller]
   29 ?        I<     0:00 [devfreq_wq]
   30 ?        I<     0:00 [watchdogd]
   31 ?        I      0:00 [kworker/u2:1]
   32 ?        I      0:00 [kworker/0:1]
   34 ?        S      0:00 [kswapd0]
   35 ?        I<     0:00 [kworker/u3:0]
   36 ?        S      0:00 [ecryptfs-kthrea]
   78 ?        I<     0:00 [kthrotld]
   79 ?        I<     0:00 [acpi_thermal_pm]
   80 ?        S      0:00 [scsi_eh_0]
   81 ?        I<     0:00 [scsi_tmf_0]
   82 ?        S      0:00 [scsi_eh_1]
   83 ?        I<     0:00 [scsi_tmf_1]
   86 ?        I      0:00 [kworker/u2:3]
   89 ?        I<     0:00 [ipv6_addrconf]
   98 ?        I<     0:00 [kstrp]
  115 ?        I<     0:00 [charger_manager]
  166 ?        I      0:00 [kworker/0:2]
  212 ?        S      0:00 [scsi_eh_2]
  213 ?        I<     0:00 [scsi_tmf_2]
  214 ?        I<     0:00 [ttm_swap]
  217 ?        I<     0:00 [kworker/0:1H]
  222 ?        I<     0:00 [kdmflush]
  223 ?        I<     0:00 [bioset]
  225 ?        I<     0:00 [kdmflush]
  226 ?        I<     0:00 [bioset]
  303 ?        I<     0:00 [raid5wq]
  371 ?        S      0:00 [jbd2/dm-0-8]
  372 ?        I<     0:00 [ext4-rsv-conver]
  428 ?        S<s    0:00 /lib/systemd/systemd-journald
  438 ?        I<     0:00 [iscsi_eh]
  444 ?        I<     0:00 [ib-comp-wq]
  445 ?        I<     0:00 [ib-comp-unb-wq]
  446 ?        I<     0:00 [ib_mcast]
  447 ?        I<     0:00 [ib_nl_sa_wq]
  448 ?        I<     0:00 [rdma_cm]
  449 ?        Ss     0:00 /sbin/lvmetad -f
  457 ?        I<     0:00 [rpciod]
  458 ?        I<     0:00 [xprtiod]
  459 ?        Ss     0:00 /lib/systemd/systemd-udevd
  483 ?        Ss     0:00 /sbin/rpcbind -f -w
  491 ?        Ss     0:00 /lib/systemd/systemd-networkd
  502 ?        Ss     0:00 /lib/systemd/systemd-resolved
  528 ?        I<     0:00 [iprt-VBoxWQueue]
  691 ?        Ss     0:00 /usr/sbin/cron -f
  692 ?        Ss     0:00 /usr/sbin/atd -f
  693 ?        Ssl    0:00 /usr/lib/accountsservice/accounts-daemon
  695 ?        Ssl    0:00 /usr/bin/python3 /usr/bin/networkd-dispatcher --run-startup-triggers
  696 ?        Ss     0:00 /lib/systemd/systemd-logind
  697 ?        Ssl    0:00 /usr/bin/lxcfs /var/lib/lxcfs/
  700 ?        Ss     0:00 /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --syslog-only
  735 ?        Ssl    0:00 /usr/sbin/rsyslogd -n
  740 ?        Ssl    0:00 /usr/lib/policykit-1/polkitd --no-debug
  924 ?        Sl     0:00 /usr/sbin/VBoxService --pidfile /var/run/vboxadd-service.sh
  951 ?        Ss     0:00 /usr/sbin/sshd -D
  960 tty1     Ss+    0:00 /sbin/agetty -o -p -- \u --noclear tty1 linux
  978 ?        Ss     0:00 sshd: vagrant [priv]
  989 ?        Ss     0:00 sshd: vagrant [priv]
  990 ?        Ss     0:00 /lib/systemd/systemd --user
  999 ?        S      0:00 (sd-pam)
 1069 ?        S      0:00 sshd: vagrant@notty
 1070 ?        S      0:00 sshd: vagrant@pts/0
 1071 ?        Ss     0:00 /usr/lib/openssh/sftp-server
 1072 pts/0    Ss     0:00 -bash
 1139 pts/0    R+     0:00 ps -ax`
````
