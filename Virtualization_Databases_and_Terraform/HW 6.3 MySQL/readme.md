### Задача 1

	* Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.
	* Изучите бэкап БД и восстановитесь из него.
	* Перейдите в управляющую консоль mysql внутри контейнера.
	* Используя команду \h получите список управляющих команд.
	* Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД.
	* Подключитесь к восстановленной БД и получите список таблиц из этой БД.
	* Приведите в ответе количество записей с price > 300.
	* В следующих заданиях мы будем продолжать работу с данным контейнером.

Скачиваем образ mysql 8.0
```
root@debian11:~# docker pull mysql:8.0
```

Создаем том vol_mysql
```
root@debian11:~# docker volume create volume_mysql
volume_mysql
```

Копируем из предварительно-скачанного репозитория, дамп БД (test_dump.sql) 
```
cp virt-homeworks-master/06-db-03-mysql/test_data/test_dump.sql /var/lib/docker/volumes/vol_mysql/_data/
```

Запускаем контейнер со скачнным образом mysql 8.0, c окружением дефолтного юзера, задаем пароль, порт и подключаем папку vol_mysql(с дампом БД) к контейнеру (в такой путь /etc/mysql/), указываем образ контейнера.
```
root@debian11:/home/user# docker run --name mysql -it -e MYSQL_ROOT_PASSWORD=mysql -p 3306:3306 -v vol_mysql:/etc/mysql/ mysql:8.0
```


Контейнер 3f5cc6a45a01 поднялся. Заходим внутрь контейнера.
```
root@debian11:/home/def_user# docker ps
CONTAINER ID   IMAGE       COMMAND                  CREATED         STATUS         PORTS                               NAMES
3f5cc6a45a01   mysql:8.0   "docker-entrypoint.s…"   3 minutes ago   Up 3 minutes   0.0.0.0:3306->3306/tcp, 33060/tcp   mysql

root@debian11:/home/def_user# docker exec -it   3f5cc6a45a01 bash
```

Убеждаемся что в нашем контейнере действительно лежит dump базы данных 
```
root@3f5cc6a45a01:/etc/mysql/backup# ls -l
-rw-r--r-- 1 root root 2073 Dec 21 10:32 test_dump.sql
```

Создаем пустую, одноименную с восстанавливаемой, базу данных test_db внутри контейнера 
```
root@3f5cc6a45a01:/etc/mysql/backup# mysql -u root -p
Enter password:
mysql> create database test_db;
Query OK, 1 row affected (0.02 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| test_db            |
+--------------------+
5 rows in set (0.00 sec)

```

Перенаправляем бэкап в созданную базу данных
```
root@3f5cc6a45a01:/etc/mysql/backup# mysql -u root -p  < test_dump.sql test_db
Enter password:
root@3f5cc6a45a01:/etc/mysql/backup# mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 12
Server version: 8.0.28 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
```

Просмотр восстановленных таблиц "orders"
```
mysql> use test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.01 sec)

mysql> select * from orders;
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  1 | War and Peace         |   100 |
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
5 rows in set (0.00 sec)
```

Команда для выдачи статуса БД.
```
mysql> \s
--------------
mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          12
Current database:       test_db
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.28 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 1 hour 28 min 41 sec

Threads: 2  Questions: 51  Slow queries: 0  Opens: 167  Flush tables: 3  Open tables: 85  Queries per second avg: 0.009
--------------
```

Количество записей с price > 300;
```
mysql> select count(*) from orders where price >300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)

```

### Задача 2

#### Создайте пользователя test в БД c паролем test-pass, используя:

    * плагин авторизации mysql_native_password
    * срок истечения пароля - 180 дней
    * количество попыток авторизации - 3
    * максимальное количество запросов в час - 100
    * аттрибуты пользователя:
        Фамилия "Pretty"
        Имя "James"

#### Предоставьте привелегии пользователю test на операции SELECT базы test_db.
#### Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test и приведите в ответе к задаче.

````
mysql> CREATE USER test@localhost IDENTIFIED WITH mysql_native_password BY 'test-pass';
Query OK, 0 rows affected (0.01 sec)

mysql> ALTER USER 'test'@'localhost' ATTRIBUTE '{"fname":"James", "lname":"Pretty"}';
Query OK, 0 rows affected (0.00 sec)

mysql> ALTER USER 'test'@'localhost' WITH MAX_QUERIES_PER_HOUR 100 PASSWORD EXPIRE INTERVAL 180 DAY FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2;
Query OK, 0 rows affected (0.02 sec)

mysql> GRANT Select ON test_db.* TO 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.01 sec)


mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)
````

### Задача 3

#### Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES;.
#### Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.
#### Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:

* на MyISAM
* на InnoDB

Установливаем профилирование SET profiling = 1. 

При выводе профилирования команд SHOW PROFILES наблюдаем скорость обработки зпроса (duration);.

В таблице БД test_db используется Eengine  InnoDB.

```
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> SHOW PROFILES;
Empty set, 1 warning (0.00 sec)

mysql> SELECT TABLE_NAME,ENGINE FROM information_schema.TABLES WHERE table_name = 'orders' and  TABLE_SCHEMA = 'test_db';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.00 sec)

mysql> SHOW PROFILES;
+----------+------------+--------------------------------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                                              |
+----------+------------+--------------------------------------------------------------------------------------------------------------------+
|        1 | 0.01357100 | SELECT TABLE_NAME,ENGINE FROM information_schema.TABLES WHERE table_name = 'orders' and  TABLE_SCHEMA = 'test_db'; |
+----------+------------+--------------------------------------------------------------------------------------------------------------------+
1 row in set, 1 warning (0.00 sec)
```

Меняем движок ENGINE c InnoDB на MyISAM и далее обратно.
```
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.02 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.03 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILES;
+----------+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                                                                                                                |
+----------+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|        1 | 0.00021150 | SET profiling = 1                                                                                                                                                                    |
|        2 | 0.02475100 | ALTER TABLE orders ENGINE = MyISAM                                                                                                                                                   |
|        3 | 0.03362925 | ALTER TABLE orders ENGINE = InnoDB                                                                                                                                                   |
+----------+------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
4 rows in set, 1 warning (0.00 sec)
```

### Задача 4
#### Изучите файл my.cnf в директории /etc/mysql.
#### Измените его согласно ТЗ (движок InnoDB):

 * Скорость IO важнее сохранности данных
 * Нужна компрессия таблиц для экономии места на диске
 * Размер буффера с незакомиченными транзакциями 1 Мб
 * Буффер кеширования 30% от ОЗУ
 * Размер файла логов операций 100 Мб

 * Приведите в ответе измененный файл my.cnf.
 
```
root@3f5cc6a45a01:/etc/mysql# cat  my.cnf
# Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

#
# The MySQL  Server configuration file.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

#Скорость IO важнее сохранности данных
innodb_flush_log_at_trx_commit = 2
innodb_flush_method = O_DSYNC

#Размер файла логов операций 100 Мб(Обычно innodb_log_file_size 25% от innodb_buffer_pool_size)
innodb_log_file_size = 104857600

# движок базы данных InnoDB поддерживает несколько форматов файлов. По умолчанию в InnoDB используется «старый» формат Antelope
# Формат файлов Barracuda — самый «новый» и поддерживает компрессию
innodb_file_format=Barracuda

#Буффер кеширования 30% от ОЗУ. ОЗУ = 5ГБ.
innodb_buffer_pool_size  = 1610612736

#Размер буффера с незакомиченными транзакциями 1 Мб
innodb_log_buffer_size = 1М

# Custom config should go here
!includedir /etc/mysql/conf.d/
```
