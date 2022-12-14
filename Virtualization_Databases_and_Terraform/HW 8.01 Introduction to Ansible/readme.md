#08.01 Введение в Ansible

>Подготовка к выполнению
>
>   Установите ansible версии 2.10 или выше.
>   Создайте свой собственный публичный репозиторий на github с произвольным именем.
>   Скачайте playbook из репозитория с домашним заданием и перенесите его в свой репозиторий.
>
>Основная часть
>
>  * Попробуйте запустить playbook на окружении из test.yml, зафиксируйте какое значение имеет факт some_fact для указанного хоста при выполнении playbook'a.
> 
>  * Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
>  * Воспользуйтесь подготовленным (используется docker) или создайте собственное окружение для проведения дальнейших испытаний.
>  * Проведите запуск playbook на окружении из prod.yml. Зафиксируйте полученные значения some_fact для каждого из managed host.
>  * Добавьте факты в group_vars каждой из групп хостов так, чтобы для some_fact получились следующие значения: для deb - 'deb default fact', для el - 'el default fact'.
>  * Повторите запуск playbook на окружении prod.yml. Убедитесь, что выдаются корректные значения для всех хостов.
>  * При помощи ansible-vault зашифруйте факты в group_vars/deb и group_vars/el с паролем netology.
>  * Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь в работоспособности.
>  * Посмотрите при помощи ansible-doc список плагинов для подключения. Выберите подходящий для работы на control node.
>  * В prod.yml добавьте новую группу хостов с именем local, в ней разместите localhost с необходимым типом подключения.
>  * Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь что факты some_fact для каждого из хостов определены из верных group_vars.
>  * Заполните README.md ответами на вопросы. Сделайте git push в ветку master. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым playbook и заполненным README.md.

### *Установите ansible версии 2.10 или выше*
#### Скачиваем get-pip.py
```bash
root@revers-proxy ~# curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 2500k  100 2500k    0     0  5762k      0 --:--:-- --:--:-- --:--:-- 5748k
```
#### Но устанавливается с WARNING и ругается на пути
```bash
root@revers-proxy ~# python3 get-pip.py --user
Collecting pip
  Downloading pip-22.2.2-py3-none-any.whl (2.0 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 2.0/2.0 MB 8.7 MB/s eta 0:00:00
Installing collected packages: pip
  WARNING: The scripts pip, pip3 and pip3.9 are installed in '/root/.local/bin' which is not on PATH.
  Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
Successfully installed pip-22.2.2
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
```
#### Посмотрим пути и пропишем для ansibe
```bash
root@revers-proxy ~/.local/bin# echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```
```bash
root@revers-proxy ~/.local/bin# export PATH="/root/.local/bin:$PATH"
root@revers-proxy ~/.local/bin# echo $PATH
/root/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```
#### Версия ansible выше `2.10`
```bash
root@revers-proxy ~# ansible --version
ansible [core 2.13.2]
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /root/.local/lib/python3.9/site-packages/ansible
  ansible collection location = /root/.ansible/collections:/usr/share/ansible/collections
  executable location = /root/.local/bin/ansible
  python version = 3.9.2 (default, Feb 28 2021, 17:03:44) [GCC 10.2.1 20210110]
  jinja version = 3.1.2
  libyaml = True
```
### *Создайте свой собственный публичный репозиторий на github с произвольным именем.*
### https://github.com/aleksandrakuzina/08.01-Ansible
### *Попробуйте запустить playbook на окружении из test.yml, зафиксируйте какое значение имеет факт some_fact для указанного хоста при выполнении playbook'a.*
```bash
root@revers-proxy ~/.../08-ansible-01-base/playbook# ansible-playbook -i inventory/test.yml site.yml

PLAY [Print os facts] *******************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] *************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Debian"
}

TASK [Print fact] ***********************************************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP ******************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
### Ответ: `some_fact=12`

### *Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.*

```bash
/.../group_vars/all# cat examp.yml
---
  some_fact: all default fact
```
```bash
root@revers-proxy ~/.../08-ansible-01-base/playbook# ansible-playbook -i inventory/test.yml site.yml

PLAY [Print os facts] *******************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] *************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Debian"
}

TASK [Print fact] ***********************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ******************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

### *Воспользуйтесь подготовленным (используется docker) или создайте собственное окружение для проведения дальнейших испытаний.*

#### Установим docker
```bash
root@revers-proxy ~# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/docker-ce-archive-keyring.gpg > /dev/null
^C
gpg: signal Interrupt caught ... exiting
```
```bash
root@revers-proxy ~# wget https://download.docker.com/linux/debian/gpg
--2022-08-09 12:23:18--  https://download.docker.com/linux/debian/gpg
Resolving download.docker.com (download.docker.com)... 65.9.66.125, 65.9.66.46, 65.9.66.72, ...
Connecting to download.docker.com (download.docker.com)|65.9.66.125|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 3817 (3.7K) [binary/octet-stream]
Saving to: ‘gpg’

gpg                                         100%[========================================================================================>]   3.73K  --.-KB/s    in 0s

2022-08-09 12:23:18 (75.7 MB/s) - ‘gpg’ saved [3817/3817]
root@revers-proxy ~# cat ./gpg | gpg --dearmor | sudo tee /usr/share/keyrings/docker-ce-archive-keyring.gpg > /dev/null
root@revers-proxy ~# ll /usr/share/keyrings/docker-ce-archive-keyring.gpg
-rw-r--r-- 1 root root 2760 Aug  9 12:37 /usr/share/keyrings/docker-ce-archive-keyring.gpg
root@revers-proxy ~# echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-ce-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

```bash
root@revers-proxy .../apt/sources.list.d# sudo apt -y install docker-ce docker-ce-cli containerd.io
(завершилось с ошибками:
...
Get:1 http://mirror.mephi.ru/debian bullseye/main amd64 pigz amd64 2.6-1 [64.0 kB]
Get:2 http://mirror.mephi.ru/debian bullseye/main amd64 dbus-user-session amd64 1.12.20-2 [96.2 kB]
Get:3 http://mirror.mephi.ru/debian bullseye/main amd64 libip6tc2 amd64 1.8.7-1 [35.0 kB]
Get:4 http://mirror.mephi.ru/debian bullseye/main amd64 libnfnetlink0 amd64 1.0.1-3+b1 [13.9 kB]
Get:5 http://mirror.mephi.ru/debian bullseye/main amd64 libnetfilter-conntrack3 amd64 1.0.8-3 [40.6 kB]
Get:6 http://mirror.mephi.ru/debian bullseye/main amd64 iptables amd64 1.8.7-1 [382 kB]
Get:7 http://mirror.mephi.ru/debian bullseye/main amd64 libltdl7 amd64 2.4.6-15 [391 kB]
Get:8 http://mirror.mephi.ru/debian bullseye/main amd64 libslirp0 amd64 4.4.0-1+deb11u2 [57.9 kB]
Get:9 http://mirror.mephi.ru/debian bullseye/main amd64 slirp4netns amd64 1.0.1-2 [33.4 kB]
Err:10 https://download.docker.com/linux/debian bullseye/stable amd64 containerd.io amd64 1.6.7-1
  Cannot initiate the connection to download.docker.com:443 (2600:9000:20eb:e600:3:db06:4200:93a1). - connect (101: Network is unreachable) Cannot initiate the connection to download.docker.com:443 (2600:9000:20eb:f000:3:db06:4200:93a1). - connect (101: Network is unreachable) Cannot initiate the connection to download.docker.com:443 (2600:9000:20eb:be00:3:db06:4200:93a1). - connect (101: Network is unreachable) Cannot initiate the connection to download.docker.com:443 (2600:9000:20eb:fe00:3:db06:4200:93a1). - connect (101: Network is unreachable) Cannot initiate the connection to download.docker.com:443 (2600:9000:20eb:ae00:3:db06:4200:93a1). - connect (101: Network is unreachable) Cannot initiate the connection to download.docker.com:443 (2600:9000:20eb:f200:3:db06:4200:93a1). - connect (101: Network is unreachable) Cannot initiate the connection to download.docker.com:443 (2600:9000:20eb:ba00:3:db06:4200:93a1). - connect (101: Network is unreachable) Cannot initiate the connection to download.docker.com:443 (2600:9000:20eb:5e00:3:db06:4200:93a1). - connect (101: Network is unreachable) Could not connect to download.docker.com:443 (13.224.189.54), connection timed out Could not connect to download.docker.com:443 (13.224.189.57), connection timed out Could not connect to download.docker.com:443 (13.224.189.92), connection timed out Could not connect to download.docker.com:443 (13.224.189.9), connection timed out
...
)
```
```bash
root@revers-proxy .../apt/sources.list.d# apt-get -y install containerd.io
root@revers-proxy .../apt/sources.list.d# sudo apt -y install docker-ce docker-ce-cli containerd.io
```
```bash
root@revers-proxy .../apt/sources.list.d# sudo systemctl start docker
root@revers-proxy .../apt/sources.list.d# sudo systemctl status docker
● docker.service - Docker Application Container Engine
     Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2022-08-09 12:56:59 MSK; 29s ago
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
   Main PID: 128083 (dockerd)
      Tasks: 8
     Memory: 36.2M
        CPU: 378ms
     CGroup: /system.slice/docker.service
             └─128083 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

Aug 09 12:56:57 revers-proxy dockerd[128083]: time="2022-08-09T12:56:57.925790965+03:00" level=info msg="scheme \"unix\" not registered, fallback to default scheme" module=>
Aug 09 12:56:57 revers-proxy dockerd[128083]: time="2022-08-09T12:56:57.925819631+03:00" level=info msg="ccResolverWrapper: sending update to cc: {[{unix:///run/containerd/>
Aug 09 12:56:57 revers-proxy dockerd[128083]: time="2022-08-09T12:56:57.925847505+03:00" level=info msg="ClientConn switching balancer to \"pick_first\"" module=grpc
Aug 09 12:56:57 revers-proxy dockerd[128083]: time="2022-08-09T12:56:57.984055765+03:00" level=info msg="Loading containers: start."
Aug 09 12:56:59 revers-proxy dockerd[128083]: time="2022-08-09T12:56:59.025056260+03:00" level=info msg="Default bridge (docker0) is assigned with an IP address 172.17.0.0/>
Aug 09 12:56:59 revers-proxy dockerd[128083]: time="2022-08-09T12:56:59.265776742+03:00" level=info msg="Loading containers: done."
Aug 09 12:56:59 revers-proxy dockerd[128083]: time="2022-08-09T12:56:59.299568975+03:00" level=info msg="Docker daemon" commit=a89b842 graphdriver(s)=overlay2 version=20.10>
Aug 09 12:56:59 revers-proxy dockerd[128083]: time="2022-08-09T12:56:59.300087339+03:00" level=info msg="Daemon has completed initialization"
Aug 09 12:56:59 revers-proxy systemd[1]: Started Docker Application Container Engine.
Aug 09 12:56:59 revers-proxy dockerd[128083]: time="2022-08-09T12:56:59.341672946+03:00" level=info msg="API listen on /run/docker.sock"
```
#### Скачиваем образы ubuntu и centos:7
```bash
root@revers-proxy .../apt/sources.list.d# docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: alleksandra
Password:
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
root@revers-proxy .../apt/sources.list.d# docker pull pycontribs/centos:7
7: Pulling from pycontribs/centos
2d473b07cdd5: Pull complete
43e1b1841fcc: Pull complete
85bf99ab446d: Pull complete
Digest: sha256:b3ce994016fd728998f8ebca21eb89bf4e88dbc01ec2603c04cc9c56ca964c69
Status: Downloaded newer image for pycontribs/centos:7
docker.io/pycontribs/centos:7

root@revers-proxy .../apt/sources.list.d# docker pull pycontribs/ubuntu:latest
latest: Pulling from pycontribs/ubuntu
423ae2b273f4: Pull complete
de83a2304fa1: Pull complete
f9a83bce3af0: Pull complete
b6b53be908de: Pull complete
7378af08dad3: Pull complete
Digest: sha256:dcb590e80d10d1b55bd3d00aadf32de8c413531d5cc4d72d0849d43f45cb7ec4
Status: Downloaded newer image for pycontribs/ubuntu:latest
docker.io/pycontribs/ubuntu:latest
```
#### Просматриваем скаченные docker образы
```bash
root@revers-proxy .../apt/sources.list.d# docker image list
REPOSITORY          TAG       IMAGE ID       CREATED         SIZE
pycontribs/centos   7         bafa54e44377   15 months ago   488MB
pycontribs/ubuntu   latest    42a4e3b21923   2 years ago     664MB
```
#### Запускаем docker образы
```bash
root@revers-proxy .../apt/sources.list.d# docker run -d --name centos7 bafa54e44377 /bin/sleep 1000
142b99500e54bb15d630fc30f825b29d083585d89b2c1cc4cc88790411a15ddc
root@revers-proxy .../apt/sources.list.d#  docker run -d --name ubuntu 42a4e3b21923 /bin/sleep 1000
b4f2e6ae454a486627b76be9fe7aab4286d70e2f5c1eb2cc892cc59e58e4fcd9

root@revers-proxy .../apt/sources.list.d# docker ps -a
CONTAINER ID   IMAGE          COMMAND             CREATED              STATUS              PORTS     NAMES
b4f2e6ae454a   42a4e3b21923   "/bin/sleep 1000"   About a minute ago   Up About a minute             ubuntu
142b99500e54   bafa54e44377   "/bin/sleep 1000"   2 minutes ago        Up 2 minutes                  centos7
```

### *Проведите запуск playbook на окружении из prod.yml. Зафиксируйте полученные значения some_fact для каждого из managed host*
```bash
root@revers-proxy ~/.../08-ansible-01-base/playbook# ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] *******************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***********************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP ******************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
#### Ответ: Для `CentOS` some_fact = el

#### Ответ: Для `ubuntu` some_fact = deb
### *Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для deb - `'deb default fact'`, для el - `'el default fact'`.*
#### В `group_vars/deb/examp.yml` и `group_vars/el/examp.yml` изменяем значения для deb - `'deb default fact'`, для el - `'el default fact'`
```bash
root@revers-proxy ~/.../08-ansible-01-base/playbook# cat group_vars/deb/examp.yml
---
  some_fact: "deb default fact"
root@revers-proxy ~/.../08-ansible-01-base/playbook# cat group_vars/el/examp.yml
---
  some_fact: "el default fact"
```
#### Playbook отрабатывает корректно
```bash
root@revers-proxy ~/.../08-ansible-01-base/playbook# ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] *******************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***********************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ******************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
### *При помощи ansible-vault зашифруйте факты в group_vars/deb и group_vars/el с паролем netology.*
```bash
root@revers-proxy ~/.../08-ansible-01-base/playbook# ansible-vault encrypt group_vars/deb/examp.yml group_vars/el/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
```
### Проверяем и пытаемся прочитать файлы
```bash
root@revers-proxy ~/.../08-ansible-01-base/playbook# cat group_vars/deb/examp.yml
$ANSIBLE_VAULT;1.1;AES256
39363932383437626135336263356665386663616666636661666438623237633766393235396535
3733616434663732656638363963373331313134666635630a396633353663653362393733373265
37376362653533303636386462393833653831663364626463613238313337616534653836353132
3736653263303337310a623761393361396432633836343439333230306434616639363738613066
39326531656464616165363131393266366239346539316162383364653364333030653033353136
3737373935323731343736643631666665626534636564303866
```
```bash
root@revers-proxy ~/.../08-ansible-01-base/playbook# cat group_vars/el/examp.yml
$ANSIBLE_VAULT;1.1;AES256
36326338386630393631336165643633353461623631306332373265386435643032666163646263
3934623735613835313336336234393431326165643930360a363764663932313635366331323666
32616464336362363465663466366562353263613664643538323831383664643863336539333131
6531333234323462610a616362626264323764316666306263306334316563613265613366653661
33623232356662396639356238646635333466623935393335643835326266623338613633656161
3437376534346137613937303535373762646630396236373663
```
### *Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь в работоспособности.*

### Запускаем стандартным образом playbook что невозможна расшифровка не может найти пароль
```bash
root@revers-proxy ~/.../08-ansible-01-base/playbook# ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] *******************************************************************************************************************************************************
ERROR! Attempting to decrypt but no vault secrets found
```
### Запускаем с запросом `--ask-vault-pass` ввода пароля: 
```bash
root@revers-proxy ~/.../08-ansible-01-base/playbook# ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] *******************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***********************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ******************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
### *Посмотрите при помощи ansible-doc список плагинов для подключения. Выберите подходящий для работы на control node*

#### Подходящий плагин для работы на control node `local` т.к. control node расположены на локальном сервере.

### *В prod.yml добавьте новую группу хостов с именем local, в ней разместите localhost с необходимым типом подключения.*
```bash
root@revers-proxy ~/.../08-ansible-01-base/playbook# cat inventory/prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
```

### *Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь что факты some_fact для каждого из хостов определены из верных group_vars.*

```bash
root@revers-proxy ~/.../08-ansible-01-base/playbook# ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] *******************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Debian"
}

TASK [Print fact] ***********************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ******************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

