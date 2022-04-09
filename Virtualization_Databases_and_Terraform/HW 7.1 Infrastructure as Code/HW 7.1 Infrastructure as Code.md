### Задача 1
#### Вам, как девопс инженеру, будет необходимо принять решение об инструментах для организации инфраструктуры. На данный момент в вашей компании уже используются следующие инструменты:

* остатки Сloud Formation,
* некоторые образы сделаны при помощи Packer,
* год назад начали активно использовать Terraform,
* разработчики привыкли использовать Docker,
* уже есть большая база Kubernetes конфигураций,
* для автоматизации процессов используется Teamcity,
* также есть совсем немного Ansible скриптов,
* и ряд bash скриптов для упрощения рутинных задач.

#### Для этого в рамках совещания надо будет выяснить подробности о проекте, что бы в итоге определиться с инструментами:
#### *Какой тип инфраструктуры будем использовать для этого проекта: изменяемый или не изменяемый?*
#### *Будет ли центральный сервер для управления инфраструктурой?*
#### *Будут ли агенты на серверах?*
#### *Будут ли использованы средства для управления конфигурацией или инициализации ресурсов?*
#### В связи с тем, что проект стартует уже сегодня, в рамках совещания надо будет определиться со всеми этими вопросами.*

##### Какой тип инфраструктуры будем использовать для этого проекта: изменяемый или не изменяемый?
Выбираю неизменяемый тип инфраструктуры, т.к. в изменяемом возникает проблема дрейфа конфигураций, что негативно скажется на большом количестве релизов, тестирования интеграций, откатов и доработок.

##### Будет ли центральный сервер для управления инфраструктурой?
Выбираю вариант без централизованного сервера, чтобы минимизировать дополнительную инфраструктуру и обслуживание.

##### Будут ли агенты на серверах?
да, например node_exporter, который собирает данные о вычислительных ресурсах: загрузку процессора, памяти, диска итд.b(также ессть zabbix, telegraf и т.д.)

##### Будут ли использованы средства для инициализации ресурсов или управлением конфигурацией?
При выборе между управлением конфигурацией или инициализацией ресурсов, выбираю последнюю. инициализация ресурсов отвечает больше за создание самих серверов, а Средства управления конфигурауией предназначены больше для установки и администрирования ПО на существующих серверах. 
 Т.к. год назад начали активно использовать Terraform и есть остатки Сloud Formation, то следовательно более предпочтительна инициализация ресурсов.

### Задача 2

Установите `terraform` при помощи менеджера пакетов используемого в вашей операционной системе. В виде результата этой задачи приложите вывод команды `terraform --version`.

* Добавим ключи GPG для APT:
````
root@vagrant:/home/vagrant# curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
OK
````

* Добавим репозиторий для APT:
````
root@vagrant:/home/vagrant# apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
Hit:1 https://apt.releases.hashicorp.com focal InRelease
Reading package lists... Done
````

* Сделаем апдейт информации о пакетах:
````
root@vagrant:/home/vagrant# apt-get update
Get:1 https://apt.releases.hashicorp.com focal InRelease [16.3 kB]
Get:2 https://apt.releases.hashicorp.com focal/main amd64 Packages [50.8 kB]
Fetched 67.0 kB in 2s (40.4 kB/s)
Reading package lists... Done
````

* Установим `terraform` через APT:
````
root@vagrant:/home/vagrant# apt-get install terraform
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following NEW packages will be installed:
  terraform
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 18.8 MB of archives.
After this operation, 63.3 MB of additional disk space will be used.
Get:1 https://apt.releases.hashicorp.com focal/main amd64 terraform amd64 1.1.7 [18.8 MB]
Fetched 18.8 MB in 6s (3,115 kB/s)
Selecting previously unselected package terraform.
(Reading database ... 87437 files and directories currently installed.)
Preparing to unpack .../terraform_1.1.7_amd64.deb ...
Unpacking terraform (1.1.7) ...
Setting up terraform (1.1.7) ...
````

* Отобразим версию скачанного пакета:
````
root@vagrant:/home/vagrant# terraform --version
Terraform v1.1.7
on linux_amd64
````

### Задача 3

В какой-то момент вы обновили `terraform` до новой версии, например с 0.12 до 0.13. А код одного из проектов настолько устарел, что не может работать с версией 0.13. В связи с этим необходимо сделать так, чтобы вы могли одновременно использовать последнюю версию `terraform`а, установленную при помощи штатного менеджера пакетов, и устаревшую версию 0.12.

В виде результата этой задачи приложите вывод --version двух версий `terraform` доступных на вашем компьютере или виртуальной машине.

* Скачаем `terraform` с зеркала `yandexcloud` и проверим контрольную сумму файла:
````
root@vagrant:/home/vagrant# curl https://hashicorp-releases.website.yandexcloud.net/terraform/1.1.6/terraform_1.1.6_linux_amd64.zip --output terraform_1.1.6_linux_amd64.zip && sha256sum terraform_1.1.6_linux_amd64.zip
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 17.8M  100 17.8M    0     0  23.1M      0 --:--:-- --:--:-- --:--:-- 23.1M
3e330ce4c8c0434cdd79fe04ed6f6e28e72db44c47ae50d01c342c8a2b05d331  terraform_1.1.6_linux_amd64.zip
````

* Распакуем архив:
````
root@vagrant:/home/vagrant# unzip terraform_1.1.6_linux_amd64.zip
Archive:  terraform_1.1.6_linux_amd64.zip
  inflating: terraform
````

* Отобразим версию скачанного бинарника:
````
root@vagrant:/home/vagrant# ./terraform --version
Terraform v1.1.6
on linux_amd64

Your version of Terraform is out of date! The latest version
is 1.1.7. You can update by downloading from https://www.terraform.io/downloads.html
````

* Отобразим версию скачанного через APT бинарника:
````
root@vagrant:/home/vagrant# terraform --version
Terraform v1.1.7
on linux_amd64
````