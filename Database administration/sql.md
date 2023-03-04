## Задача 1
Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

    root@test:~/netology/sql# cat docker-compose.yml 
    version: '3.6'

    volumes:
      data: {}
      backup: {}

    services:
      postgres:
        image: postgres:12
        restart: always
        container_name: postgres

        environment:
          POSTGRES_USER: "test-admin-user"
          POSTGRES_PASSWORD: "test"
          POSTGRES_DB: "test_db"

        volumes: 
          - data:/var/lib/postgresql/data
          - backup:/var/lib/postgresql/backup

        ports:
          - 0.0.0.0:5432:5432

## Задача 2
В БД из задачи 1:
+ создайте пользователя test-admin-user и БД test_db
#####
    root@test:~/netology/sql# docker exec -it postgres bash
    root@2f67aa7cb7c1:/# psql -h localhost -U test-admin-user -W test_db     
    Password: 
    psql (12.14 (Debian 12.14-1.pgdg110+1))
    Type "help" for help.

    test_db=# \l+
                                                                               List of databases
       Name    |      Owner      | Encoding |  Collate   |   Ctype    |            Access privileges            |  Size   | Tablespace |                Description                 
    -----------+-----------------+----------+------------+------------+-----------------------------------------+---------+------------+--------------------------------------------
     postgres  | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 |                                         | 7969 kB | pg_default | default administrative connection database
     template0 | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +| 7825 kB | pg_default | unmodifiable empty database
               |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user" |         |            | 
     template1 | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +| 7825 kB | pg_default | default template for new databases
               |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user" |         |            | 
     test_db   | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 |                                         | 7969 kB | pg_default | 
    (4 rows)

    test_db=# 
#####
+ в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
#####
    test_db=# CREATE TABLE orders ( id SERIAL, Наименование VARCHAR, Цена INT, PRIMARY KEY (id) );
    CREATE TABLE

    test_db=# CREATE TABLE clients ( id SERIAL, Фамилия VARCHAR, "Страна проживания" VARCHAR, Заказ INT, PRIMARY KEY (id), FOREIGN KEY (Заказ) REFERENCES orders (id) );  
    CREATE TABLE

    test_db=# CREATE INDEX ON clients("Страна проживания"); 
    CREATE INDEX
#####
+ предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
#####
    test_db=# GRANT ALL ON TABLE orders, clients TO "test-admin-user";
    GRANT
#####
+ создайте пользователя test-simple-user
#####
    test_db=# CREATE USER "test-simple-user" WITH PASSWORD 'test2';
    CREATE ROLE
#####
+ предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
#####
    test_db=# GRANT CONNECT ON DATABASE test_db TO "test-simple-user";
    GRANT

    test_db=# GRANT USAGE ON SCHEMA public TO "test-simple-user";
    GRANT
    
    test_db=# GRANT SELECT, INSERT, UPDATE, DELETE ON orders, clients TO "test-simple-user";
    GRANT

Приведите:
+ итоговый список БД после выполнения пунктов выше,
#####
    test_db=# \l+
                                                                                   List of databases
       Name    |      Owner      | Encoding |  Collate   |   Ctype    |            Access privileges            |  Size   | Tablespace |                Description                 
    -----------+-----------------+----------+------------+------------+-----------------------------------------+---------+------------+--------------------------------------------
     postgres  | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 |                                         | 7969 kB | pg_default | default administrative connection database
     template0 | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +| 7825 kB | pg_default | unmodifiable empty database
               |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user" |         |            | 
     template1 | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +| 7825 kB | pg_default | default template for new databases
               |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user" |         |            | 
     test_db   | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/"test-admin-user"                  +| 8121 kB | pg_default | 
               |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user"+|         |            | 
               |                 |          |            |            | "test-simple-user"=c/"test-admin-user"  |         |            | 
    (4 rows)
#####
+ описание таблиц (describe)
#####
    test_db=# \d+ clients
                                                               Table "public.clients"
          Column       |       Type        | Collation | Nullable |               Default               | Storage  | Stats target | Description 
    -------------------+-------------------+-----------+----------+-------------------------------------+----------+--------------+-------------
     id                | integer           |           | not null | nextval('clients_id_seq'::regclass) | plain    |              | 
     Фамилия           | character varying |           |          |                                     | extended |              | 
     Страна проживания | character varying |           |          |                                     | extended |              | 
     Заказ             | integer           |           |          |                                     | plain    |              | 
    Indexes:
        "clients_pkey" PRIMARY KEY, btree (id)
        "clients_Страна проживания_idx" btree ("Страна проживания")
    Foreign-key constraints:
        "clients_Заказ_fkey" FOREIGN KEY ("Заказ") REFERENCES orders(id)
    Access method: heap

    test_db=# \d+ orders
                                                          Table "public.orders"
     Column  |       Type        | Collation | Nullable |              Default               | Storage  | Stats target | Description 
    ---------+-------------------+-----------+----------+------------------------------------+----------+--------------+-------------
     id      | integer           |           | not null | nextval('orders_id_seq'::regclass) | plain    |              | 
     Фамилия | character varying |           |          |                                    | extended |              | 
     Цена    | integer           |           |          |                                    | plain    |              | 
    Indexes:
        "orders_pkey" PRIMARY KEY, btree (id)
    Referenced by:
        TABLE "clients" CONSTRAINT "clients_Заказ_fkey" FOREIGN KEY ("Заказ") REFERENCES orders(id)
    Access method: heap
#####
+ SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
#####
    SELECT 
        grantee, table_name, privilege_type 
    FROM 
        information_schema.table_privileges 
    WHERE 
        grantee in ('test-admin-user','test-simple-user')
        and table_name in ('clients','orders')
    order by 
        1,2,3;
#####
+ список пользователей с правами над таблицами test_db
#####
         grantee      | table_name | privilege_type 
    ------------------+------------+----------------
     test-admin-user  | clients    | DELETE
     test-admin-user  | clients    | INSERT
     test-admin-user  | clients    | REFERENCES
     test-admin-user  | clients    | SELECT
     test-admin-user  | clients    | TRIGGER
     test-admin-user  | clients    | TRUNCATE
     test-admin-user  | clients    | UPDATE
     test-admin-user  | orders     | DELETE
     test-admin-user  | orders     | INSERT
     test-admin-user  | orders     | REFERENCES
     test-admin-user  | orders     | SELECT
     test-admin-user  | orders     | TRIGGER
     test-admin-user  | orders     | TRUNCATE
     test-admin-user  | orders     | UPDATE
     test-simple-user | clients    | DELETE
     test-simple-user | clients    | INSERT
     test-simple-user | clients    | SELECT
     test-simple-user | clients    | UPDATE
     test-simple-user | orders     | DELETE
     test-simple-user | orders     | INSERT
     test-simple-user | orders     | SELECT
     test-simple-user | orders     | UPDATE
    (22 rows)
## Задача 3
Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:
Таблица orders

| Наименование | цена |
|--------------|-----|
| Шоколад      | 10  |
| Принтер      | 3000 |
| Книга        | 500 |
| Монитор      | 7000 |
| Гитара       | 4000 |

    test_db=# INSERT INTO orders VALUES (1, 'Шоколад', 10), (2, 'Принтер', 3000), (3, 'Книга', 500), (4, 'Монитор', 7000), (5, 'Гитара', 4000);
    INSERT 0 5

    test_db=# SELECT * FROM orders;
     id | Наименование | Цена 
    ----+--------------+------
      1 | Шоколад      |   10
      2 | Принтер      | 3000
      3 | Книга        |  500
      4 | Монитор      | 7000
      5 | Гитара       | 4000
    (5 rows)

 Таблица clients

| ФИО                  | Страна проживания |
|----------------------|-------------------|
| Иванов Иван Иванович | USA               |
| Петров Петр Петрович | Canada            |
| Иоганн Себастьян Бах | Japan             |
| Ронни Джеймс Дио     | Russia            |
| Ritchie Blackmore    | Russia            |

    test_db=# INSERT INTO clients VALUES (1, 'Иванов Иван Иванович', 'USA'), (2, 'Петров Петр Петрович', 'Canada'), (3, 'Иоганн Себастьян Бах', 'Japan'), (4, 'Ронни Джеймс Дио', 'Russia'), (5, 'Ritchie Blackmore', 'Russia');
    INSERT 0 5

    test_db=# SELECT * FROM clients;
     id |       Фамилия        | Страна проживания | Заказ 
    ----+----------------------+-------------------+-------
      1 | Иванов Иван Иванович | USA               |      
      2 | Петров Петр Петрович | Canada            |      
      3 | Иоганн Себастьян Бах | Japan             |      
      4 | Ронни Джеймс Дио     | Russia            |      
      5 | Ritchie Blackmore    | Russia            |      
    (5 rows)
Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы

Приведите в ответе:

- запросы,
- результаты их выполнения.


    test_db=# SELECT count(1) FROM orders;        
     count 
    -------
         5
    (1 row)

    test_db=# SELECT count(1) FROM clients;
     count 
    -------
         5
    (1 row)

## Задача 4
Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys, свяжите записи из таблиц, согласно таблице:

| ФИО                       | 	Заказ |
|---------------------------|--------|
| Иванов Иван Иванович      | Книга  |
| Петров Петр Петрович      | Монитор |
| Иоганн Себастьян Бах      | Гитара |

Приведите SQL-запросы для выполнения этих операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод этого запроса.

Подсказка: используйте директиву UPDATE.

    test_db=# UPDATE clients SET "Заказ" = (SELECT id FROM orders WHERE "Наименование"='Книга') WHERE "Фамилия"='Иванов Иван Иванович';
    UPDATE 1
    test_db=# UPDATE clients SET "Заказ" = (SELECT id FROM orders WHERE "Наименование"='Монитор') WHERE "Фамилия"='Петров Петр Петрович'; 
    UPDATE 1
    test_db=# UPDATE clients SET "Заказ" = (SELECT id FROM orders WHERE "Наименование"='Гитара') WHERE "Фамилия"='Иоганн Себастьян Бах';   
    UPDATE 1

    test_db=# SELECT c.* FROM clients c JOIN orders o ON c.Заказ = o.id; 
     id |       Фамилия        | Страна проживания | Заказ 
    ----+----------------------+-------------------+-------
      1 | Иванов Иван Иванович | USA               |     3
      2 | Петров Петр Петрович | Canada            |     4
      3 | Иоганн Себастьян Бах | Japan             |     5
    (3 rows)

    test_db=# SELECT * FROM clients;
     id |       Фамилия        | Страна проживания | Заказ 
    ----+----------------------+-------------------+-------
      4 | Ронни Джеймс Дио     | Russia            |      
      5 | Ritchie Blackmore    | Russia            |      
      1 | Иванов Иван Иванович | USA               |     3
      2 | Петров Петр Петрович | Canada            |     4
      3 | Иоганн Себастьян Бах | Japan             |     5
    (5 rows)

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).

Приведите получившийся результат и объясните, что значат полученные значения.

    test_db=# EXPLAIN SELECT c.* FROM clients c JOIN orders o ON c.Заказ = o.id;          
                               QUERY PLAN                               
    ------------------------------------------------------------------------
     Hash Join  (cost=37.00..57.24 rows=810 width=72)
       Hash Cond: (c."Заказ" = o.id)
       ->  Seq Scan on clients c  (cost=0.00..18.10 rows=810 width=72)
       ->  Hash  (cost=22.00..22.00 rows=1200 width=4)
             ->  Seq Scan on orders o  (cost=0.00..22.00 rows=1200 width=4)
    (5 rows)

Сначала просматривается таблица orders. Вычисляется хэш по полю id.
Потом просматривается таблица clients. Вычисляется хэш по каждой строки поля Заказ, который сравнивается с хешем поля id таблицы orders.
Если соответствия найдено, выводится результирующая строка. Если соответствия нет, то строка будет пропущена.

## Задача 6
Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. задачу 1).

Остановите контейнер с PostgreSQL, но не удаляйте volumes.

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления.

    root@2f67aa7cb7c1:/# export PGPASSWORD=test && pg_dumpall -h localhost -U test-admin-user > /media/postgresql/backup/test_db.sql        
    root@2f67aa7cb7c1:/# ls /media/postgresql/backup/
    test_db.sql

    root@2f67aa7cb7c1:/# exit
    exit

    root@test:~/netology/sql# docker-compose stop
    [+] Running 1/1
     ⠿ Container postgres  Stopped                                                                                                                                                                                                     0.2s

    root@test:~/netology/sql# docker ps -a
    CONTAINER ID   IMAGE         COMMAND                  CREATED       STATUS                      PORTS     NAMES
    2f67aa7cb7c1   postgres:12   "docker-entrypoint.s…"   3 hours ago   Exited (0) 17 seconds ago             postgres

    root@test:~/netology/sql# docker run --rm -d -e POSTGRES_USER=test-admin-user -e POSTGRES_PASSWORD=test -e POSTGRES_DB=test_db -v sql_backup:/media/postgresql/backup --name postgres2 postgres:12                   
    8ae5e869886aa4d1900556f22732e4115088bda85d7adf0d4ce81781eded90fb

    root@test:~/netology/sql# docker ps -a
    CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS                     PORTS      NAMES
    8ae5e869886a   postgres:12   "docker-entrypoint.s…"   7 seconds ago   Up 6 seconds               5432/tcp   postgres2
    2f67aa7cb7c1   postgres:12   "docker-entrypoint.s…"   3 hours ago     Exited (0) 4 minutes ago              postgres

    root@test:~/netology/sql# docker exec -it postgres2 bash
    root@b7c1b879e819:/# ls /media/postgresql/backup/
    test_db.sql

    root@b7c1b879e819:/# export PGPASSWORD=test && psql -h localhost -U test-admin-user -f /media/postgresql/backup/test_db.sql test_db        
    SET
    SET
    SET
    psql:/media/postgresql/backup/test_db.sql:14: ERROR:  role "test-admin-user" already exists
    ALTER ROLE
    CREATE ROLE
    ...
    (1 row)
    ALTER TABLE
    ALTER TABLE
    CREATE INDEX
    ALTER TABLE
    GRANT
    GRANT
    GRANT
    GRANT

    root@b7c1b879e819:/# psql -h localhost -U test-admin-user -W test_db
    Password: 
    psql (12.14 (Debian 12.14-1.pgdg110+1))
    Type "help" for help.

    test_db=#

    test_db=# \l+
                                                                               List of databases
       Name    |      Owner      | Encoding |  Collate   |   Ctype    |            Access privileges            |  Size   | Tablespace |                Description                 
    -----------+-----------------+----------+------------+------------+-----------------------------------------+---------+------------+--------------------------------------------
     postgres  | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 |                                         | 7969 kB | pg_default | default administrative connection database
     template0 | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +| 7825 kB | pg_default | unmodifiable empty database
               |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user" |         |            | 
     template1 | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +| 7969 kB | pg_default | default template for new databases
               |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user" |         |            | 
     test_db   | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/"test-admin-user"                  +| 8161 kB | pg_default | 
               |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user"+|         |            | 
               |                 |          |            |            | "test-simple-user"=c/"test-admin-user"  |         |            | 
    (4 rows)

    test_db=# SELECT * FROM clients;
     id |       Фамилия        | Страна проживания | Заказ 
    ----+----------------------+-------------------+-------
      4 | Ронни Джеймс Дио     | Russia            |      
      5 | Ritchie Blackmore    | Russia            |      
      1 | Иванов Иван Иванович | USA               |     3
      2 | Петров Петр Петрович | Canada            |     4
      3 | Иоганн Себастьян Бах | Japan             |     5
    (5 rows)

    test_db=# 