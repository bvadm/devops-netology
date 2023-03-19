# Домашнее задание к занятию 4. «PostgreSQL»
## Задача 1
#### Используя Docker, поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
    root@test:~# docker run --rm --name pgsql -p 5432:5432 -e POSTGRES_USER=test-user -e POSTGRES_PASSWORD=test -v pgsql_data:/var/lib/postgresql/data -d postgres:13
    bb1df28d3882d1307e39547ad138b760c883e4c118f0d6ad1500d0273624a346
    root@test:~# docker ps
    CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS                                       NAMES
    bb1df28d3882   postgres:13   "docker-entrypoint.s…"   3 seconds ago   Up 2 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   pgsql
#### Подключитесь к БД PostgreSQL, используя psql.
    root@bb1df28d3882:/# psql -U test-user -W
    Password: 
    psql (13.10 (Debian 13.10-1.pgdg110+1))
    Type "help" for help.
    
    test-user=# 
#### Воспользуйтесь командой \? для вывода подсказки по имеющимся в psql управляющим командам.
#### Найдите и приведите управляющие команды для:
+ вывода списка БД,
####
    test-user=# \l+
                                                                      List of databases
       Name    |   Owner   | Encoding |  Collate   |   Ctype    |      Access privileges      |  Size   | Tablespace |                Description                 
    -----------+-----------+----------+------------+------------+-----------------------------+---------+------------+--------------------------------------------
     postgres  | test-user | UTF8     | en_US.utf8 | en_US.utf8 |                             | 7901 kB | pg_default | default administrative connection database
     template0 | test-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-user"             +| 7753 kB | pg_default | unmodifiable empty database
               |           |          |            |            | "test-user"=CTc/"test-user" |         |            | 
     template1 | test-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-user"             +| 7753 kB | pg_default | default template for new databases
               |           |          |            |            | "test-user"=CTc/"test-user" |         |            | 
     test-user | test-user | UTF8     | en_US.utf8 | en_US.utf8 |                             | 7901 kB | pg_default | 
    (4 rows)
+ подключения к БД,
####
    test-user=# \conninfo
    You are connected to database "test-user" as user "test-user" via socket in "/var/run/postgresql" at port "5432".
+ вывода списка таблиц,
####
    test-user=# \dtS
                        List of relations
       Schema   |          Name           | Type  |   Owner   
    ------------+-------------------------+-------+-----------
     pg_catalog | pg_aggregate            | table | test-user
     pg_catalog | pg_am                   | table | test-user
     pg_catalog | pg_amop                 | table | test-user
     pg_catalog | pg_amproc               | table | test-user
     pg_catalog | pg_attrdef              | table | test-user
     pg_catalog | pg_attribute            | table | test-user
     pg_catalog | pg_auth_members         | table | test-user
     pg_catalog | pg_authid               | table | test-user
     pg_catalog | pg_cast                 | table | test-user
     pg_catalog | pg_class                | table | test-user
     pg_catalog | pg_collation            | table | test-user
     pg_catalog | pg_constraint           | table | test-user
     pg_catalog | pg_conversion           | table | test-user
     pg_catalog | pg_database             | table | test-user
     pg_catalog | pg_db_role_setting      | table | test-user
     pg_catalog | pg_default_acl          | table | test-user
     pg_catalog | pg_depend               | table | test-user
     pg_catalog | pg_description          | table | test-user
     pg_catalog | pg_enum                 | table | test-user
     pg_catalog | pg_event_trigger        | table | test-user
     pg_catalog | pg_extension            | table | test-user
     pg_catalog | pg_foreign_data_wrapper | table | test-user
     pg_catalog | pg_foreign_server       | table | test-user
     pg_catalog | pg_foreign_table        | table | test-user
     pg_catalog | pg_index                | table | test-user
     pg_catalog | pg_inherits             | table | test-user
     pg_catalog | pg_init_privs           | table | test-user
     pg_catalog | pg_language             | table | test-user
     pg_catalog | pg_largeobject          | table | test-user
     pg_catalog | pg_largeobject_metadata | table | test-user
     pg_catalog | pg_namespace            | table | test-user
     pg_catalog | pg_opclass              | table | test-user
     pg_catalog | pg_operator             | table | test-user
     pg_catalog | pg_opfamily             | table | test-user
     pg_catalog | pg_partitioned_table    | table | test-user
     pg_catalog | pg_policy               | table | test-user
     pg_catalog | pg_proc                 | table | test-user
     pg_catalog | pg_publication          | table | test-user
     pg_catalog | pg_publication_rel      | table | test-user
     pg_catalog | pg_range                | table | test-user
     pg_catalog | pg_replication_origin   | table | test-user
     pg_catalog | pg_rewrite              | table | test-user
     pg_catalog | pg_seclabel             | table | test-user
     pg_catalog | pg_sequence             | table | test-user
     pg_catalog | pg_shdepend             | table | test-user
     pg_catalog | pg_shdescription        | table | test-user
     pg_catalog | pg_shseclabel           | table | test-user
     pg_catalog | pg_statistic            | table | test-user
     pg_catalog | pg_statistic_ext        | table | test-user
     pg_catalog | pg_statistic_ext_data   | table | test-user
     pg_catalog | pg_subscription         | table | test-user
     pg_catalog | pg_subscription_rel     | table | test-user
     pg_catalog | pg_tablespace           | table | test-user
     pg_catalog | pg_transform            | table | test-user
     pg_catalog | pg_trigger              | table | test-user
     pg_catalog | pg_ts_config            | table | test-user
     pg_catalog | pg_ts_config_map        | table | test-user
     pg_catalog | pg_ts_dict              | table | test-user
     pg_catalog | pg_ts_parser            | table | test-user
     pg_catalog | pg_ts_template          | table | test-user
     pg_catalog | pg_type                 | table | test-user
     pg_catalog | pg_user_mapping         | table | test-user
    (62 rows)
+ вывода описания содержимого таблиц,
####
    test-user=# \dS+
                                                 List of relations
       Schema   |              Name               | Type  |   Owner   | Persistence |    Size    | Description 
    ------------+---------------------------------+-------+-----------+-------------+------------+-------------
     pg_catalog | pg_aggregate                    | table | test-user | permanent   | 56 kB      | 
     pg_catalog | pg_am                           | table | test-user | permanent   | 40 kB      | 
     pg_catalog | pg_amop                         | table | test-user | permanent   | 80 kB      | 
     pg_catalog | pg_amproc                       | table | test-user | permanent   | 64 kB      | 
     pg_catalog | pg_attrdef                      | table | test-user | permanent   | 8192 bytes | 
     pg_catalog | pg_attribute                    | table | test-user | permanent   | 456 kB     | 
     pg_catalog | pg_auth_members                 | table | test-user | permanent   | 40 kB      | 
     pg_catalog | pg_authid                       | table | test-user | permanent   | 48 kB      | 
     pg_catalog | pg_available_extension_versions | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_available_extensions         | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_cast                         | table | test-user | permanent   | 48 kB      | 
     pg_catalog | pg_class                        | table | test-user | permanent   | 136 kB     | 
     pg_catalog | pg_collation                    | table | test-user | permanent   | 240 kB     | 
     pg_catalog | pg_config                       | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_constraint                   | table | test-user | permanent   | 48 kB      | 
     pg_catalog | pg_conversion                   | table | test-user | permanent   | 48 kB      | 
     pg_catalog | pg_cursors                      | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_database                     | table | test-user | permanent   | 48 kB      | 
     pg_catalog | pg_db_role_setting              | table | test-user | permanent   | 8192 bytes | 
     pg_catalog | pg_default_acl                  | table | test-user | permanent   | 8192 bytes | 
     pg_catalog | pg_depend                       | table | test-user | permanent   | 488 kB     | 
     pg_catalog | pg_description                  | table | test-user | permanent   | 376 kB     | 
     pg_catalog | pg_enum                         | table | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_event_trigger                | table | test-user | permanent   | 8192 bytes | 
     pg_catalog | pg_extension                    | table | test-user | permanent   | 48 kB      | 
     pg_catalog | pg_file_settings                | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_foreign_data_wrapper         | table | test-user | permanent   | 8192 bytes | 
     pg_catalog | pg_foreign_server               | table | test-user | permanent   | 8192 bytes | 
     pg_catalog | pg_foreign_table                | table | test-user | permanent   | 8192 bytes | 
     pg_catalog | pg_group                        | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_hba_file_rules               | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_index                        | table | test-user | permanent   | 64 kB      | 
     pg_catalog | pg_indexes                      | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_inherits                     | table | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_init_privs                   | table | test-user | permanent   | 56 kB      | 
     pg_catalog | pg_language                     | table | test-user | permanent   | 48 kB      | 
     pg_catalog | pg_largeobject                  | table | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_largeobject_metadata         | table | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_locks                        | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_matviews                     | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_namespace                    | table | test-user | permanent   | 48 kB      | 
     pg_catalog | pg_opclass                      | table | test-user | permanent   | 48 kB      | 
     pg_catalog | pg_operator                     | table | test-user | permanent   | 144 kB     | 
     pg_catalog | pg_opfamily                     | table | test-user | permanent   | 48 kB      | 
     pg_catalog | pg_partitioned_table            | table | test-user | permanent   | 8192 bytes | 
     pg_catalog | pg_policies                     | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_policy                       | table | test-user | permanent   | 8192 bytes | 
     pg_catalog | pg_prepared_statements          | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_prepared_xacts               | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_proc                         | table | test-user | permanent   | 688 kB     | 
     pg_catalog | pg_publication                  | table | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_publication_rel              | table | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_publication_tables           | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_range                        | table | test-user | permanent   | 40 kB      | 
     pg_catalog | pg_replication_origin           | table | test-user | permanent   | 8192 bytes | 
     pg_catalog | pg_replication_origin_status    | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_replication_slots            | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_rewrite                      | table | test-user | permanent   | 656 kB     | 
     pg_catalog | pg_roles                        | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_rules                        | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_seclabel                     | table | test-user | permanent   | 8192 bytes | 
     pg_catalog | pg_seclabels                    | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_sequence                     | table | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_sequences                    | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_settings                     | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_shadow                       | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_shdepend                     | table | test-user | permanent   | 40 kB      | 
     pg_catalog | pg_shdescription                | table | test-user | permanent   | 48 kB      | 
     pg_catalog | pg_shmem_allocations            | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_shseclabel                   | table | test-user | permanent   | 8192 bytes | 
     pg_catalog | pg_stat_activity                | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_all_indexes             | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_all_tables              | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_archiver                | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_bgwriter                | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_database                | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_database_conflicts      | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_gssapi                  | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_progress_analyze        | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_progress_basebackup     | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_progress_cluster        | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_progress_create_index   | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_progress_vacuum         | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_replication             | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_slru                    | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_ssl                     | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_subscription            | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_sys_indexes             | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_sys_tables              | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_user_functions          | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_user_indexes            | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_user_tables             | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_wal_receiver            | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_xact_all_tables         | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_xact_sys_tables         | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_xact_user_functions     | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stat_xact_user_tables        | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_statio_all_indexes           | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_statio_all_sequences         | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_statio_all_tables            | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_statio_sys_indexes           | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_statio_sys_sequences         | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_statio_sys_tables            | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_statio_user_indexes          | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_statio_user_sequences        | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_statio_user_tables           | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_statistic                    | table | test-user | permanent   | 248 kB     | 
     pg_catalog | pg_statistic_ext                | table | test-user | permanent   | 8192 bytes | 
     pg_catalog | pg_statistic_ext_data           | table | test-user | permanent   | 8192 bytes | 
     pg_catalog | pg_stats                        | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_stats_ext                    | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_subscription                 | table | test-user | permanent   | 8192 bytes | 
     pg_catalog | pg_subscription_rel             | table | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_tables                       | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_tablespace                   | table | test-user | permanent   | 48 kB      | 
     pg_catalog | pg_timezone_abbrevs             | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_timezone_names               | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_transform                    | table | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_trigger                      | table | test-user | permanent   | 8192 bytes | 
     pg_catalog | pg_ts_config                    | table | test-user | permanent   | 40 kB      | 
     pg_catalog | pg_ts_config_map                | table | test-user | permanent   | 56 kB      | 
     pg_catalog | pg_ts_dict                      | table | test-user | permanent   | 48 kB      | 
     pg_catalog | pg_ts_parser                    | table | test-user | permanent   | 40 kB      | 
     pg_catalog | pg_ts_template                  | table | test-user | permanent   | 40 kB      | 
     pg_catalog | pg_type                         | table | test-user | permanent   | 120 kB     | 
     pg_catalog | pg_user                         | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_user_mapping                 | table | test-user | permanent   | 8192 bytes | 
     pg_catalog | pg_user_mappings                | view  | test-user | permanent   | 0 bytes    | 
     pg_catalog | pg_views                        | view  | test-user | permanent   | 0 bytes    | 
    (129 rows)
+ выход из psql.
####
    test-user=# \q
    root@bb1df28d3882:/# 
## Задача 2
#### Используя psql, создайте БД test_database.
    test-user=# create database test_database owner "test-user";
    CREATE DATABASE
#### Изучите бэкап БД.
#### Восстановите бэкап БД в test_database.
    root@test:~# docker cp test_dump.sql pgsql:/tmp
    Preparing to copy...
    Copying to container - 4.096kB
    Successfully copied 4.096kB to pgsql:/tmp
    
    root@test:~# docker exec -t pgsql bash

    root@bb1df28d3882:/# psql -U test-user -W -f /tmp/test_dump.sql test_database
    Password: 
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
    ALTER TABLE
    CREATE SEQUENCE
    ALTER TABLE
    ALTER SEQUENCE
    ALTER TABLE
    COPY 8
    setval 
    --------
          8
    (1 row)

    ALTER TABLE

#### Перейдите в управляющую консоль psql внутри контейнера.
    root@bb1df28d3882:/# psql -U test-user -W
    Password: 
    psql (13.10 (Debian 13.10-1.pgdg110+1))
    Type "help" for help.

    test-user=# 
#### Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
    test-user=# \c test_database 
    Password: 
    You are now connected to database "test_database" as user "test-user".

    test_database=# ANALYZE VERBOSE public.orders;
    INFO:  analyzing "public.orders"
    INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
    ANALYZE
#### Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.
#### Приведите в ответе команду, которую вы использовали для вычисления, и полученный результат.
    test_database=# select attname, avg_width from pg_stats where tablename='orders';
     attname | avg_width 
    ---------+-----------
     id      |         4
     title   |        16
     price   |         4
    (3 rows)
## Задача 3
#### Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам как успешному выпускнику курсов DevOps в Нетологии предложили провести разбиение таблицы на 2: шардировать на orders_1 - price>499 и orders_2 - price<=499.
#### Предложите SQL-транзакцию для проведения этой операции.
    test_database=# create table orders_more_499 (like orders);
    CREATE TABLE
    test_database=# insert into orders_more_499 select * from orders where price >499;
    INSERT 0 3
    test_database=# create table orders_less_499 (like orders);
    CREATE TABLE
    test_database=# insert into orders_less_499 select * from orders where price <=499;
    INSERT 0 5
    test_database=# delete from only orders;
    DELETE 8
    
    test_database=# \dt
                  List of relations
     Schema |      Name       | Type  |   Owner   
    --------+-----------------+-------+-----------
     public | orders          | table | test-user
     public | orders_less_499 | table | test-user
     public | orders_more_499 | table | test-user
    (3 rows)

    test_database=# select * from public.orders_more_499;
     id |       title        | price 
    ----+--------------------+-------
      2 | My little database |   500
      6 | WAL never lies     |   900
      8 | Dbiezdmin          |   501
    (3 rows)

    test_database=# select * from public.orders_less_499;
     id |        title         | price 
    ----+----------------------+-------
      1 | War and peace        |   100
      3 | Adventure psql time  |   300
      4 | Server gravity falls |   300
      5 | Log gossips          |   123
      7 | Me and my bash-pet   |   499
    (5 rows)
#### Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?
#### Можно, используя partition by. 

    test_database=# create table orders_test (
    test_database(# id int not null,
    test_database(# title varchar not null,
    test_database(# price int
    test_database(# ) partition by range ( price);
    CREATE TABLE
    test_database=# create table orders_test_more_499 partition of orders_test for values from ( 499) to (9999);
    CREATE TABLE
    test_database=# create table orders_test_less_499 partition of orders_test for values from ( 0) to (499);
    CREATE TABLE
    test_database=# insert into orders_test (id, title, price) select * from orders;
    INSERT 0 0
    test_database=# \dt+
                                           List of relations
     Schema |         Name         |       Type        |   Owner   | Persistence |    Size    | Description 
    --------+----------------------+-------------------+-----------+-------------+------------+-------------
     public | orders               | table             | test-user | permanent   | 8192 bytes | 
     public | orders_less_499      | table             | test-user | permanent   | 8192 bytes | 
     public | orders_more_499      | table             | test-user | permanent   | 8192 bytes | 
     public | orders_test          | partitioned table | test-user | permanent   | 0 bytes    | 
     public | orders_test_less_499 | table             | test-user | permanent   | 8192 bytes | 
     public | orders_test_more_499 | table             | test-user | permanent   | 8192 bytes | 
    (6 rows)
#### Задача 4
#### Используя утилиту pg_dump, создайте бекап БД test_database.
    root@bb1df28d3882:/# pg_dump -U test-user -W test_database > /tmp/test_database.back.sql
    Password: 

    root@bb1df28d3882:/# ls /tmp/
    test_database.back.sql  test_dump.sql

    root@bb1df28d3882:/# cat /tmp/test_database.back.sql 
    --
    -- PostgreSQL database dump
    --
    -- Dumped from database version 13.10 (Debian 13.10-1.pgdg110+1)
    -- Dumped by pg_dump version 13.10 (Debian 13.10-1.pgdg110+1)
    SET statement_timeout = 0;
    SET lock_timeout = 0;
    ................
    ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);
    --
    -- PostgreSQL database dump complete
    --
#### Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?
#### Ответ: Использовал бы индекс, для обеспечения уникальности.
![](PostgreSQL-pic.jpg)