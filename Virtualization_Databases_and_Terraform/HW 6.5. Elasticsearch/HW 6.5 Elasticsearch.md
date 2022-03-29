### Задача 1
В этом задании вы потренируетесь в:

    установке elasticsearch
    первоначальном конфигурировании elastcisearch
    запуске elasticsearch в docker

dokerfile
````
root@vagrant:/home/vagrant/elasticsearch# cat dockerfile
FROM centos:7
EXPOSE 9200
RUN adduser -mr elastic && mkdir /var/lib/elastic && chown elastic /var/lib/elastic
USER elastic
RUN cd && curl https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.1-linux-x86_64.tar.gz --output elastic.tar.gz && tar -xvf elastic.tar.gz && rm elastic.tar.gz
ENV ES_HOME=./elasticsearch-8.1.1
ADD elasticsearch.yml $ES_HOME/config/elasticsearch.yml
RUN cd && echo "node.name: netology_test" >> $ES_HOME/config/elasticsearch.yml && echo "path.data: /var/lib/elastic" >> $ES_HOME/config/elasticsearch.yml
CMD $HOME/$ES_HOME/bin/elasticsearch
````

docker build ./
````
...
Step 5/9 : RUN cd && curl https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.1-linux-x86_64.tar.gz --output elastic.tar.gz && tar -xvf elastic.tar.gz && rm elastic.tar.gz
 ---> Running in 5da8968bd132
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   134  100   134    0     0    251      0 --:--:-- --:--:-- --:--:--   251
tar: This does not look like a tar archive

gzip: stdin: not in gzip format
tar: Child returned status 1
tar: Error is not recoverable: exiting now
````


Здесь, в dockefile, изменены лишь ключи в распаковке файла "tar -cfxvz"
````
root@vagrant:/home/vagrant/elasticsearch# docker build ./
Sending build context to Docker daemon  515.8MB
Step 1/9 : FROM centos:7
 ---> eeb6ee3f44bd
Step 2/9 : EXPOSE 9200
 ---> Using cache
 ---> 5da4e47c8e3b
Step 3/9 : RUN adduser -mr elastic && mkdir /var/lib/elastic && chown elastic /var/lib/elastic
 ---> Using cache
 ---> 21c992c65180
Step 4/9 : USER elastic
 ---> Using cache
 ---> 185b555092e8
Step 5/9 : RUN cd && curl https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.1-linux-x86_64.tar.gz --output elastic.tar.gz && tar -cfxvz elastic.tar.gz && rm elastic.tar.gz
 ---> Running in 1f06cbc7fe7f
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   134  100   134    0     0    363      0 --:--:-- --:--:-- --:--:--   363
Removing intermediate container 1f06cbc7fe7f
 ---> 70d9d782eaf2
Step 6/9 : ENV ES_HOME=./elasticsearch-8.1.1
 ---> Running in acd6d56b69ab
Removing intermediate container acd6d56b69ab
 ---> a9d2e87cc003
Step 7/9 : ADD elasticsearch.yml $ES_HOME/config/elasticsearch.yml
ADD failed: file not found in build context or excluded by .dockerignore: stat elasticsearch.yml: file does not exist
````











*Используя докер образ centos:7 как базовый и документацию по установке и запуску Elastcisearch:*

* составьте Dockerfile-манифест для elasticsearch
* соберите docker-образ и сделайте push в ваш docker.io репозиторий
* запустите контейнер из получившегося образа и выполните запрос пути / c хост-машины

Требования к elasticsearch.yml:
  * *данные path должны сохраняться в /var/lib*
  * *имя ноды должно быть netology_test*

В ответе приведите:
* текст Dockerfile манифеста
* ссылку на образ в репозитории dockerhub
* ответ elasticsearch на запрос пути / в json виде

Подсказки:

*возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum*

*при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml*

*при некоторых проблемах вам поможет docker директива ulimit*

*elasticsearch в логах обычно описывает проблему и пути ее решения*

*Далее мы будем работать с данным экземпляром elasticsearch.*

### Задача 2

В этом задании вы научитесь:

    создавать и удалять индексы
    изучать состояние кластера
    обосновывать причину деградации доступности данных

* Ознакомтесь с документацией и добавьте в elasticsearch 3 индекса, в соответствии с таблицей:

Имя | Количество реплик | Количество шард
------ | ------------ | ------
ind-1  |  0           | 1  
ind-2  |  1           | 2
ind-3  |  2           | 4  



* Получите список индексов и их статусов, используя API и приведите в ответе на задание.
* Получите состояние кластера elasticsearch, используя API.
* Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?
* Удалите все индексы.

*Важно:При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард, иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.*

### Задача 3

В данном задании вы научитесь:

     создавать бэкапы данных
     восстанавливать индексы из бэкапов

* Создайте директорию {путь до корневой директории с elasticsearch в образе}/snapshots.

* Используя API зарегистрируйте данную директорию как snapshot repository c именем netology_backup.

* Приведите в ответе запрос API и результат вызова API для создания репозитория.

* Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.

* Создайте snapshot состояния кластера elasticsearch.

* Приведите в ответе список файлов в директории со snapshotами.

* Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов.

* Восстановите состояние кластера elasticsearch из snapshot, созданного ранее.

* Приведите в ответе запрос к API восстановления и итоговый список индексов.

Подсказки:
*возможно вам понадобится доработать elasticsearch.yml в части директивы path.repo и перезапустить elasticsearch*
