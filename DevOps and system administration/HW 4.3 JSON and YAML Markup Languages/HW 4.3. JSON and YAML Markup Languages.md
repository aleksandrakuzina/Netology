
### 1. Мы выгрузили JSON, который получили через API запрос к нашему сервису:

    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }

### Нужно найти и исправить все ошибки, которые допускает наш сервис

*Нарушен синтаксис написания json, в том что, внутри массива элементы не разделены запятой и пары ключ значения потеряны кавычки*

````
{ "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            },
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
  }
	
````
### 2. В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: { "имя сервиса" : "его IP"}. Формат записи YAML по одному сервису: - имя сервиса: его IP. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

> Мой скрипт:
````python
#!/usr/bin/env python3
import os.path
import socket

hosts = ["drive.google.com", "mail.google.com", "google.com"]
last_check_filepath = 'myfile.txt'
json_file = 'myfile.json'
yaml_file = 'myfile.yaml'
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
    
def write_to_json(ip_by_host):
    remove_file(json_file)
    fp = open(json_file, 'w')
    for (host, port) in ip_by_host.items():
        fp.write("{ \""+host+"\" : \""+port+"\" }\n")
    fp.close()    


def write_to_yaml(ip_by_host):
    remove_file(yaml_file)
    fp = open(yaml_file, 'w')
    for (host, port) in ip_by_host.items():
        fp.write("- "+host+": "+port+ "\n")
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
write_to_json(ip_by_host)
write_to_yaml(ip_by_host)
````
> Вывод скрипта при запуске при тестировании:

````
root@debian11:~# ./hw4_2.py
drive.google.com 64.233.164.194
Error oldip[209.85.233.194] != new ip[64.233.164.194] for host drive.google.com
mail.google.com 173.194.222.83
Error oldip[64.233.165.83] != new ip[173.194.222.83] for host mail.google.com
google.com 108.177.14.101
Error oldip[64.233.165.139] != new ip[108.177.14.101] for host google.com
````

> json-файл(ы), который(е) записал ваш скрипт:

````json
root@debian11:~# cat myfile.json
{ "drive.google.com" : "64.233.164.194" }
{ "mail.google.com" : "173.194.222.83" }
{ "google.com" : "108.177.14.101" }
````

> yml-файл(ы), который(е) записал ваш скрипт:

````yaml
root@debian11:~# cat myfile.yaml
- drive.google.com: 64.233.164.194
- mail.google.com: 173.194.222.17
- google.com: 142.251.1.139
````
