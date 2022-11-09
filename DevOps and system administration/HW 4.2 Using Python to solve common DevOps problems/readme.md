# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | никакого, т.к. a - число, а b - строковое значение  |
| Как получить для переменной `c` значение 12?  | поставить кавычки в значении, a '1' ,тогда путем сложения двух строк получится строковое значение 12.  |
| Как получить для переменной `c` значение 3?  | убрать кавычки из значения b, получится в значениях a, b будут числа. Т.о. 1+2=3  |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3
import os

bash_command = ["cd .", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
path = os.popen('cd . && cd').read().replace('\n', '') + '/'
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(path + prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
C:\Users\K\AppData\Local\Programs\Python\Python39\python.exe "C:/Users/Kslum/PycharmProjects/DevSys_DPC_2_Kuzina/DevOps and system administration/HW 4.2 Using Python to solve common DevOps problems/s.py"
C:\Users\K\PycharmProjects\DevSys_DPC_2_Kuzina\DevOps and system administration\HW 4.2 Using Python to solve common DevOps problems/../HW 3.9 Security elements of information systems/HW 3.9. Security elements of information systems.md

Process finished with exit code 0
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import sys

repo_path = sys.argv[1]
bash_command = ["cd " + repo_path, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
path = os.popen('cd ' + repo_path + '&& cd').read().replace('\n', '') + '/'
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(path + prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
PS C:\Users\K\PycharmProjects\DevSys_DPC_2_Kuzina\DevOps and system administration\HW 4.2 Using Python to solve common DevOps problems> C:\Users\Kslum\AppData\Local\Programs\Python\Python39\python.exe s.py .
C:\Users\K\PycharmProjects\DevSys_DPC_2_Kuzina\DevOps and system administration\HW 4.2 Using Python to solve common DevOps problems/s.py
['s.py', '..']
```


## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import os.path
import socket

hosts = ["drive.google.com", "mail.google.com", "google.com"]
last_check_filepath = 'myfile.txt'
delimiter = ";"


def remove_file(filename):
    try:
        os.remove(filename)
    except OSError:
        pass


def load_last_check():
    ip_by_host = {}
    if os.path.isfile(last_check_filepath):
        file = open(last_check_filepath, 'r')
        lines = file.readlines()
        for line in lines:
            args = line.split(delimiter)
            ip_by_host[args[0]] = args[1].replace("\n", "")
    return ip_by_host


def write_to_file(ip_by_host):
    remove_file(last_check_filepath)
    fp = open(last_check_filepath, 'w')
    for (host, port) in ip_by_host.items():
        fp.write(host + delimiter + port + "\n")
    fp.close()


ip_by_host_last = load_last_check()
ip_by_host = {}

for host in hosts:
    ip = socket.gethostbyname(host)
    ip_by_host[host] = ip
    print(host + ' ' + ip)
    oldIp = ip_by_host_last.get(host)
    if oldIp and oldIp != ip:
        print("Error oldip[" + oldIp + "] != new ip[" + ip + "] for host " + host)

write_to_file(ip_by_host)
```
### Вывод скрипта при запуске при тестировании:
```
root@debian11:~# ./hw4.py
drive.google.com 209.85.233.194
mail.google.com 64.233.165.83
google.com 64.233.165.139

root@debian11:~# ls -l
-rwxrwxrwx 1 root root 1142 фев  7 16:30 hw4.py
-rw-r--r-- 1 root root   88 фев  7 16:30 myfile.txt

root@debian11:~# cat myfile.txt
drive.google.com;209.85.233.194
mail.google.com;64.233.165.83
google.com;64.233.165.139
```