## Задача 1
#### Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.
#### Приведите получившуюся команду или docker-compose манифест.
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

    root@test:~/netology/sql# docker exec -it postgres /bin/bash
## Задача 2
#### В БД из задачи 1:
