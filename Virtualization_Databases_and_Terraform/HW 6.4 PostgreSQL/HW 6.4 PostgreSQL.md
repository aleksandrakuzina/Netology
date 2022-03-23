### Задача 1
 * Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
 * Подключитесь к БД PostgreSQL используя psql.
 * Воспользуйтесь командой \? для вывода подсказки по имеющимся в psql управляющим командам.

Скачиваем образ postresql:13 и создаем том для связи с БД 
```
root@debian11:/home/def_user# docker pull postresql:13
root@debian11:/home/def_user# docker volume create vol_pg_hw6_4
vol_pg_hw6_4
root@debian11:/home/def_user#  docker volume ls
DRIVER    VOLUME NAME
local     vol_pg_hw6_4
```

Запускаем контейнер с postgres
```
root@debian11:/var/lib# docker run -e POSTGRES_PASSWORD=123 -e POSTGRES_USER=user -p 5432:5432 -v $HOME/docker/volumes/vol_pg_hw6_4:/var/lib/pgsql/data postgres:13
root@debian11:/var/lib/docker/volumes# docker ps -a

CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS                      PORTS                               NAMES
835557467ef3   postgres:13   "docker-entrypoint.s…"   29 seconds ago   Up 28 seconds               0.0.0.0:5432->5432/tcp              nostalgic_dhawan
```

Подключаемся к БД используя psql
```
root@debian11:/var/lib/docker/volumes#  psql -h 127.0.0.1 -U user
Пароль пользователя user:
psql (13.5 (Debian 13.5-0+deb11u1), сервер 13.6 (Debian 13.6-1.pgdg110+1))
Введите "help", чтобы получить справку.

user=#
```

#### Найдите и приведите управляющие команды для:
 #### * вывода списка БД
 #### * подключения к БД
 #### * вывода списка таблиц
 #### * вывода описания содержимого таблиц
 #### * выхода из psql

Вывод списка БД
```
user=# \l
                             Список баз данных
    Имя    | Владелец | Кодировка | LC_COLLATE |  LC_CTYPE  | Права доступа
-----------+----------+-----------+------------+------------+---------------
 postgres  | user     | UTF8      | en_US.utf8 | en_US.utf8 |
 template0 | user     | UTF8      | en_US.utf8 | en_US.utf8 | =c/user      +
           |          |           |            |            | user=CTc/user
 template1 | user     | UTF8      | en_US.utf8 | en_US.utf8 | =c/user      +
           |          |           |            |            | user=CTc/user
 user      | user     | UTF8      | en_US.utf8 | en_US.utf8 |
(4 строки)

```
подключения к БД - \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
```
user=# \c user
psql (13.5 (Debian 13.5-0+deb11u1), сервер 13.6 (Debian 13.6-1.pgdg110+1))
Вы подключены к базе данных "user" как пользователь "user". 
```
Вывод списка таблиц
```
postgres=# \dtS+ 
                                        Список отношений
   Схема    |           Имя           |   Тип   | Владелец |  Хранение  |   Размер   | Описание
------------+-------------------------+---------+----------+------------+------------+----------
 pg_catalog | pg_aggregate            | таблица | user     | постоянное | 56 kB      |
 pg_catalog | pg_am                   | таблица | user     | постоянное | 40 kB      |
 pg_catalog | pg_amop                 | таблица | user     | постоянное | 80 kB      |
 pg_catalog | pg_amproc               | таблица | user     | постоянное | 64 kB      |
 pg_catalog | pg_attrdef              | таблица | user     | постоянное | 8192 bytes |
 pg_catalog | pg_attribute            | таблица | user     | постоянное | 456 kB     |
 pg_catalog | pg_auth_members         | таблица | user     | постоянное | 40 kB      |
 pg_catalog | pg_authid               | таблица | user     | постоянное | 48 kB      |
...
```
Вывод описания содержимого таблиц  \d[S+] NAME
```
user=# \dS+  pg_aggregate
                                                Таблица "pg_catalog.pg_aggregate"
     Столбец      |   Тип    | Правило сортировки | Допустимость NULL | По умолчанию | Хранилище | Цель для статистики | Описание
------------------+----------+--------------------+-------------------+--------------+-----------+---------------------+----------
 aggfnoid         | regproc  |                    | not null          |              | plain     |                     |
 aggkind          | "char"   |                    | not null          |              | plain     |                     |
 aggnumdirectargs | smallint |                    | not null          |              | plain     |                     |
...
```
Выход из psql
```
user=# \q
```

### Задача 2

 ####  * Используя psql создайте БД test_database.
 #### * Изучите бэкап БД.
 #### * Восстановите бэкап БД в test_database.
 #### * Перейдите в управляющую консоль psql внутри контейнера.
 #### * Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
 #### * Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.
 #### * Приведите в ответе команду, которую вы использовали для вычисления и полученный результат.


Создаем новый контейнер, подключая папку с test_dump.sql (ранее скопированную в vol_pg_hw6_4)
```
root@debian11:/var/lib/docker/volumes/vol_pg_hw6_4# docker run -e POSTGRES_PASSWORD=123 -e POSTGRES_USER=postgres -v $HOME/docker/volumes/vol_pg_hw6_4:/etc/backup/ postgres:13
```

Создаю базу данных test_database, а также проверяю, что в контейнере действительно есть test_dump.sql
```
root@debian11:/var/lib/docker/volumes/vol_pg_hw6_4# docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS                          PORTS
6b5856319714   postgres:13   "docker-entrypoint.s…"   21 seconds ago   Up 20 seconds                   5432/tcp

root@debian11:/var/lib/docker/volumes/vol_pg_hw6_4# docker exec -it 6b5856319714 bash
root@6b5856319714:/# ls /etc/backup/
hostname  hosts  resolv.conf  test_dump.sql

root@6b5856319714:/# psql -h localhost -p 5432 -U postgres
psql (13.6 (Debian 13.6-1.pgdg110+1))
Type "help" for help.

postgres=# CREATE DATABASE test_database;
CREATE DATABASE
postgres=# \q
```

Перенаправляем бэкап в базу данных
```
root@6b5856319714:/# psql test_database < /etc/backup/test_dump.sql
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ERROR:  must be member of role "postgres"
CREATE SEQUENCE
ERROR:  must be member of role "postgres"
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
```

Подключаемся к postgres
```
root@6b5856319714:/# psql -h localhost -p 5432 -U postgres
psql (13.6 (Debian 13.6-1.pgdg110+1))
Type "help" for help.
```

Подключаемся к БД и видим что она восстановлена
```
postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# \dt
        List of relations
 Schema |  Name  | Type  | Owner
--------+--------+-------+-------
 public | orders | table | root
(1 row)
```

Подключаемся к восстановленной БД и проводим операцию ANALYZE для сбора статистики по таблице.
```
test_database=# ANALYZE VERBOSE orders
test_database-# ;
INFO:  analyzing "public.orders" inheritance tree
INFO:  "orders_l499": scanned 1 of 1 pages, containing 4 live rows and 0 dead rows; 4 rows in sample, 4 estimated total rows
INFO:  "orders_m499": scanned 1 of 1 pages, containing 4 live rows and 0 dead rows; 4 rows in sample, 4 estimated total rows
INFO:  analyzing "public.orders_l499"
INFO:  "orders_l499": scanned 1 of 1 pages, containing 4 live rows and 0 dead rows; 4 rows in sample, 4 estimated total rows
INFO:  analyzing "public.orders_m499"
INFO:  "orders_m499": scanned 1 of 1 pages, containing 4 live rows and 0 dead rows; 4 rows in sample, 4 estimated total rows
ANALYZE
```
Используя таблицу pg_stats, находим столбец таблицы orders с наибольшим средним значением размера элементов в байтах.
Т.к. avg_width столбец типа integer показывает срений размер элементов в столбце, байты, то команда будет выглядеть следующим образом:
```
test_database=# select max(avg_width) from pg_stats where tablename='orders';
 max
-----
  16
(1 row)

```
### Задача 3

#### Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

  #### * Предложите SQL-транзакцию для проведения данной операции.
  #### * Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Ручное разбиение возможно исключить если предусматриваются какие-то шаблнные правила по сбору таблицы ( например CREATE RULE, CONSTRAINT CHECK) 

```
 test_database=# \dt
        List of relations
 Schema |  Name  | Type  | Owner
--------+--------+-------+-------
 public | orders | table | root
(1 row)

test_database=# CREATE TABLE orders_1 (CHECK (price>499)) INHERITS (orders);
CREATE TABLE
test_database=# CREATE TABLE orders_2 (CHECK (price<=499)) INHERITS (orders);
CREATE TABLE
test_database=# \dt
          List of relations
 Schema |   Name   | Type  |  Owner
--------+----------+-------+----------
 public | orders   | table | root
 public | orders_1 | table | postgres
 public | orders_2 | table | postgres
(3 rows)
```

### Задача 4

#### * Используя утилиту pg_dump создайте бекап БД test_database.
#### * Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?

 Создаем бэкап БД test_database
 ```
 root@6b5856319714:/var/lib/postgresql/data# pg_dump -U postgres test_databases > test_databases_dump.sql
 ```
 
Для уникальности можно добавить индекс CREATE INDEX ON orders (lower(title)) 

```
root@6b5856319714:/var/lib/postgresql/data# tail test_databases_dump.sql
...
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
);
...
```