# Домашнее задание к занятию 3. «MySQL»
## Задача 1
##### Используя Docker, поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.
    docker run --rm --name mysql -e MYSQL_DATABASE=test_db -e MYSQL_ROOT_PASSWORD=test -v mysql_data:/var/lib/mysql -v $PWD/netology/mysql/conf.d:/etc/mysql/conf.d -p 3306:3306 -d mysql:8
    
    root@test:~# docker ps
    CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                                                  NAMES
    bf23d28da2f5   mysql:8   "docker-entrypoint.s…"   16 seconds ago   Up 15 seconds   0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp   mysql
##### Изучите бэкап БД и восстановитесь из него.
    root@test:~/netology/mysql# docker cp test_dump.sql mysql:/tmp         
    Preparing to copy...
    Copying to container - 4.096kB
    Successfully copied 4.096kB to mysql:/tmp
    
    root@test:~/netology/mysql# docker exec -it mysql bash      

    bash-4.4# mysql -u root -p test_db < /tmp/test_dump.sql 
    Enter password: 
    bash-4.4# 

##### Перейдите в управляющую консоль mysql внутри контейнера.
    bash-4.4# mysql -u root -p
    Enter password: 
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 10
    Server version: 8.0.32 MySQL Community Server - GPL

    Copyright (c) 2000, 2023, Oracle and/or its affiliates.

    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    mysql> 
##### Используя команду \h, получите список управляющих команд.
##### Найдите команду для выдачи статуса БД и приведите в ответе из её вывода версию сервера БД.
    mysql> status
    --------------
    mysql  Ver 8.0.32 for Linux on x86_64 (MySQL Community Server - GPL)

    Connection id:          10
    Current database:
    Current user:           root@localhost
    SSL:                    Not in use
    Current pager:          stdout
    Using outfile:          ''
    Using delimiter:        ;
    Server version:         8.0.32 MySQL Community Server - GPL
    Protocol version:       10
    Connection:             Localhost via UNIX socket
    Server characterset:    utf8mb4
    Db     characterset:    utf8mb4
    Client characterset:    latin1
    Conn.  characterset:    latin1
    UNIX socket:            /var/run/mysqld/mysqld.sock
    Binary data as:         Hexadecimal
    Uptime:                 30 min 37 sec

    Threads: 2  Questions: 38  Slow queries: 0  Opens: 139  Flush tables: 3  Open tables: 57  Queries per second avg: 0.020
    --------------
##### Подключитесь к восстановленной БД и получите список таблиц из этой БД.
    mysql> use test_db;
    Database changed
    
    mysql> show tables;
    +-------------------+
    | Tables_in_test_db |
    +-------------------+
    | orders            |
    +-------------------+
    1 row in set (0.01 sec)
##### Приведите в ответе количество записей с price > 300.
    mysql> SELECT COUNT(*) FROM orders WHERE price > 300;
    +----------+
    | COUNT(*) |
    +----------+
    |        1 |
    +----------+
    1 row in set (0.00 sec)
## Задача 2
##### Создайте пользователя test в БД c паролем test-pass, используя:
+ плагин авторизации mysql_native_password
+ срок истечения пароля — 180 дней
+ количество попыток авторизации — 3
+ максимальное количество запросов в час — 100
+ аттрибуты пользователя:
+ + Фамилия "Pretty"
+ + Имя "James".
#####
    mysql> CREATE USER 'test'@'localhost'
        -> IDENTIFIED WITH mysql_native_password BY 'test-pass'
        -> WITH MAX_CONNECTIONS_PER_HOUR 100
        -> FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 3
        -> ATTRIBUTE '{"first_name":"James", "last_name":"Pretty"}';
    Query OK, 0 rows affected (0.03 sec)
##### Предоставьте привелегии пользователю test на операции SELECT базы test_db.
    mysql> GRANT SELECT ON test_db.* TO test@localhost;
    Query OK, 0 rows affected, 1 warning (0.02 sec)
##### Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES, получите данные по пользователю test и приведите в ответе к задаче.
    mysql> select * from information_schema.user_attributes where user = "test";
    +------+-----------+------------------------------------------------+
    | USER | HOST      | ATTRIBUTE                                      |
    +------+-----------+------------------------------------------------+
    | test | localhost | {"last_name": "Pretty", "first_name": "James"} |
    +------+-----------+------------------------------------------------+
    1 row in set (0.01 sec)
## Задача 3
##### Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES;.
    mysql> SET profiling = 1;
    mysql> show privileges;
    mysql> show profiles;
    +----------+------------+-------------------+
    | Query_ID | Duration   | Query             |
    +----------+------------+-------------------+
    |        9 | 0.00075300 | SET profiling = 1 |
    |       10 | 0.00558675 | show privileges   |
    +----------+------------+-------------------+
    2 rows in set, 1 warning (0.00 sec)
##### Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.
    mysql> SELECT TABLE_SCHEMA,TABLE_NAME,ENGINE FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = DATABASE();
    +--------------+------------+--------+
    | TABLE_SCHEMA | TABLE_NAME | ENGINE |
    +--------------+------------+--------+
    | test_db      | orders     | InnoDB |
    +--------------+------------+--------+
    1 row in set (0.01 sec)
##### Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:
+ на MyISAM,
+ на InnoDB.
#####
    mysql> ALTER TABLE orders ENGINE=MyISAM;
    Query OK, 5 rows affected (0.05 sec)
    Records: 5  Duplicates: 0  Warnings: 0

    mysql> SELECT TABLE_SCHEMA,TABLE_NAME,ENGINE FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = DATABASE();
    +--------------+------------+--------+
    | TABLE_SCHEMA | TABLE_NAME | ENGINE |
    +--------------+------------+--------+
    | test_db      | orders     | MyISAM |
    +--------------+------------+--------+
    1 row in set (0.01 sec)

    mysql> ALTER TABLE orders ENGINE=InnoDB;
    Query OK, 5 rows affected (0.04 sec)
    Records: 5  Duplicates: 0  Warnings: 0

    mysql> SELECT TABLE_SCHEMA,TABLE_NAME,ENGINE FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = DATABASE();
    +--------------+------------+--------+
    | TABLE_SCHEMA | TABLE_NAME | ENGINE |
    +--------------+------------+--------+
    | test_db      | orders     | InnoDB |
    +--------------+------------+--------+
    1 row in set (0.01 sec)
## Задача 4
##### Изучите файл my.cnf в директории /etc/mysql.
##### Измените его согласно ТЗ (движок InnoDB):
+ скорость IO важнее сохранности данных;
+ нужна компрессия таблиц для экономии места на диске;
+ размер буффера с незакомиченными транзакциями 1 Мб;
+ буффер кеширования 30% от ОЗУ;
+ размер файла логов операций 100 Мб.
##### Приведите в ответе изменённый файл my.cnf.
    bash-4.4# cat /etc/mysql/conf.d/my.cnf 
    # For advice on how to change settings please see
    # http://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html

    [mysqld]
    #
    # Remove leading # and set to the amount of RAM for the most important data
    # cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
    innodb_buffer_pool_size = 512M
    #
    # Remove leading # to turn on a very important data integrity option: logging
    # changes to the binary log between backups.
    # log_bin
    #
    # Remove leading # to set options mainly useful for reporting servers.
    # The server defaults are faster for transactions and fast SELECTs.
    # Adjust sizes as needed, experiment to find the optimal values.
    # join_buffer_size = 128M
    # sort_buffer_size = 2M
    # read_rnd_buffer_size = 2M

    # Remove leading # to revert to previous value for default_authentication_plugin,
    # this will increase compatibility with older clients. For background, see:
    # https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_authentication_plugin
    # default-authentication-plugin=mysql_native_password
    skip-host-cache
    skip-name-resolve
    datadir=/var/lib/mysql
    socket=/var/run/mysqld/mysqld.sock
    secure-file-priv=/var/lib/mysql-files
    user=mysql

    pid-file=/var/run/mysqld/mysqld.pid
    [client]
    socket=/var/run/mysqld/mysqld.sock

    !includedir /etc/mysql/conf.d/
    innodb_flush_log_at_trx_commit = 0
    innodb_file_per_table = 1
    innodb_log_buffer_size = 1M
    innodb_log_file_size = 100M
