# Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"
*Ссылка на ДЗ: https://github.com/netology-code/sysadm-homeworks/tree/devsys10/04-script-01-bash*
### 1.Какие значения переменным c,d,e будут присвоены? Почему?

Есть скрипт:
```bash
a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
```
### **Ответ:**
| Переменная  | Значение | Обоснование |
| ------------- | ------------- | ------------- |
| `c`  | a+b | bash воспринимает это присвоение как текст |
| `d`  | 1+2 | bash воспринимает это присвоение как текст, подставив туда числовые значения переменнных |
| `e`  | 3  | bash производит вычисления, подставляя значения в переменную. $(($a+$b)) стандартный конструктив для обертки математических операций|

### 2.На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным (после чего скрипт должен завершиться). В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:

```
while ((1==1)
do
	curl https://localhost:4757
	if (($? != 0))
	then
		date >> curl.log
	fi
done
```
### **Ответ:**
* не написана строка ввода #!/bin/bash - шебанг
* нет закрывающей скобки в конструктиве условия while, должно быть ((1==1))
* искала информацию между разницей while ((1==1)) и [1==1] и нашла объяснение https://gist.github.com/Titiaiev/dcb7298389d1276b823bbc96e29f940d где говорится о

```
[[ - расширенная версия "[" (начиная с версии 2.02)(как в примере), внутри которой могут быть использованы || (или), & (и). Долна иметь закрывающуб скобку "]]"
(( )) - математическое сравнение.
```

* в скрипт добавлено `else break` 

* Cоздан файл `skript_bash.sh` с ошибочным скриптом, но с портом 80 (т.к это должно работать  - возврат успеха 0), где увидели результат зацикленного действия вывода странички по 80 порту localhost, также замечено что файл  `curl.log` не создался после выполнения скрипта.

```
kuzina@debian ~$ ls -l
total 44
drwxr-xr-x 2 kuzina kuzina 4096 Nov 18  2020 Desktop
drwxr-xr-x 2 kuzina kuzina 4096 Nov 18  2020 Documents
drwxr-xr-x 2 kuzina kuzina 4096 Nov 18  2020 Downloads
-rw-r--r-- 1 root   root   1320 Dec  5  2002 jcameron-key.asc
drwxr-xr-x 2 kuzina kuzina 4096 Nov 18  2020 Music
drwxr-xr-x 2 kuzina kuzina 4096 Nov 18  2020 Pictures
drwxr-xr-x 2 kuzina kuzina 4096 Nov 18  2020 Public
-rwxr-xr-x 1 kuzina kuzina  108 Jan 31 18:37 skript_bash.sh
drwxr-xr-x 2 kuzina kuzina 4096 Nov 18  2020 Templates
-rw-r--r-- 1 root   root    345 Oct  5 17:01 test.conf
drwxr-xr-x 2 kuzina kuzina 4096 Nov 18  2020 Videos
```
* Добавляем в скрипт закрывающую скобку while ((1==1)) и условие else break. 
* Если первая команда возвратит не ноль, что означает её неуспешное выполнение, условие окажется ложным и запишет результат в curl.log и не пойдет по ветке else, в противном случае, при возвращении 0 (успеха выполнения команды)  пойдет по ветке else, далее break (завершение скрипта - без записи в файл curl.log.)
* Выполняем скрипт и видим, что порт 4346 несуществует на моей машине, достучаться до него невозможно - поэтому идет ветка date >> curl.log и записывает в файл и не идет по ветке else.

*Верный скрипт:*
```
#!/bin/bash
while ((1==1))
do
        curl http://localhost:4346
        if (($? != 0))
        then
                date >> curl.log
        else
                break
        fi

done
```
*результат выполнения скрипта:*
```
kuzina@debian ~$ ./skript_bash.sh
curl: (7) Failed to connect to localhost port 4346: Connection refused
curl: (7) Failed to connect to localhost port 4346: Connection refused
curl: (7) Failed to connect to localhost port 4346: Connection refused
curl: (7) Failed to connect to localhost port 4346: Connection refused
curl: (7) Failed to connect to localhost port 4346: Connection refused
curl: (7) Failed to connect to localhost port 4346: Connection refused
```
*появился файл curl.log*
```
kuzina@debian ~$ ls -l
total 52
-rw-r--r-- 1 kuzina kuzina 4128 Jan 31 18:48 curl.log
```
*запись в curl.log при недоступности ресурса происходит непрерывно:*
```
kuzina@debian ~$ cat curl.log
Thu 03 Feb 2022 05:02:11 PM MSK
Thu 03 Feb 2022 05:18:55 PM MSK
Thu 03 Feb 2022 05:18:55 PM MSK
```
*Проверяем, чтобы скрипт завершался при успешном доступе по порту :80*

*Верный скрипт:*
```
#!/bin/bash

while ((1==1))
do
        curl http://localhost:80
        if (($? != 0))
        then
                date >> curl.log
        else
                break
        fi

done
```
*Результат вывода после успешного выполнения скрипта, скрипт завершается с выводом странницы html по порту :80*

```
kuzina@debian ~$ ./skript_bash.sh

<!DOCTYPE html PUBLIC "-//........>
<html xmlns="http://xhtml">
  <head>
....
....
      </div>
    </div>
    <div class="validator">
    </div>
  </body>
</html>
```

### 3. Необходимо написать скрипт, который проверяет доступность трёх IP: `192.168.0.1`, `173.194.222.113`, `87.250.250.242` по `80` порту и записывает результат в файл `log`. Проверять доступность необходимо пять раз для каждого узла.

### **Ответ:**
*Скрипт:*
```
echo "" > curl.log
a=("192.168.0.1" "173.194.222.113" "87.250.250.242")
for i in ${a[@]}; do
  for j in {1..5}; do
    curl http://$i:80 -m 1
    if (($? != 0)); then
      echo "error " $i >>curl.log
    else
      echo "OK " $i >>curl.log
    fi
  done
done
```
*Результат вывода скрипта:*
```
kuzina@debian ~$ ./skript_bash2.sh
curl: (7) Failed to connect to 192.168.0.1 port 80: No route to host
curl: (7) Failed to connect to 192.168.0.1 port 80: No route to host
curl: (7) Failed to connect to 192.168.0.1 port 80: No route to host
curl: (7) Failed to connect to 192.168.0.1 port 80: No route to host
curl: (7) Failed to connect to 192.168.0.1 port 80: No route to host
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
```
*То что записалось в логи, видим что 192.168.0.1 - не достучался, по остальным сайтам достучался "OK"*
```
kuzina@debian ~$ cat curl.log
error  192.168.0.1
error  192.168.0.1
error  192.168.0.1
error  192.168.0.1
error  192.168.0.1
OK  173.194.222.113
OK  173.194.222.113
OK  173.194.222.113
OK  173.194.222.113
OK  173.194.222.113
OK  87.250.250.242
OK  87.250.250.242
OK  87.250.250.242
OK  87.250.250.242
OK  87.250.250.242
```
### 4. Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. 

*Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается. Т.к. изначально 192.168.0.1 недоступен, а остальные доступны - переместим 192.168.0.1 вконец проверки.*

*Скрипт:*
```
echo "" >error
echo "" >curl.log
a=( "173.194.222.113" "87.250.250.242" "192.168.0.1")
while ((1 == 1)); do
  for i in ${a[@]}; do
    curl http://$i:80 -m 1
    if (($? != 0)); then
      echo "error " $i >>error
      break 2
    else
      echo "OK " $i >>curl.log
    fi
  done
done
```

*Результат выполнения скрипта: он прервался, когда недостучался до 192.168.0.1 и записал ip в файл error.*

```
kuzina@debian ~$ ./skript_bash3.sh
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>

curl: (7) Failed to connect to 192.168.0.1 port 80: No route to host

kuzina@debian ~$ cat error
error  192.168.0.1
```