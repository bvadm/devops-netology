## Домашнее задание к занятию "3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"
### Задача 1
 - [x] создайте свой репозиторий на https://hub.docker.com;
 - [x] выберете любой образ, который содержит веб-сервер Nginx;
 - [x] создайте свой fork образа;
 - [x] реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
#####
    <html>
    <head>
    Hey, Netology
    </head>
    <body>
    <h1>I’m DevOps Engineer!</h1>
    </bdy>
    </html>
 - [x] Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.
####
### Решение: https://hub.docker.com/r/bvadm/nginx/tags
    root@test:~# docker images          
    REPOSITORY    TAG       IMAGE ID       CREATED          SIZE
    bvadm/nginx   test      ee118ee84112   39 minutes ago   142MB

    root@test:~# docker run -d -p 8080:80 --name mynginx -it bvadm/nginx:test 
    448eaea7908e4abe62f873a93144a2d0317ad7045cbc3b59c3c75696df4c1d6d
    
    root@test:~# docker ps
    CONTAINER ID   IMAGE              COMMAND                  CREATED         STATUS         PORTS                                   NAMES
    448eaea7908e   bvadm/nginx:test   "/docker-entrypoint.…"   9 seconds ago   Up 8 seconds   0.0.0.0:8080->80/tcp, :::8080->80/tcp   mynginx
    
    root@test:~# curl localhost:8080
    <html>
    <head>
    Hey, Netology
    </head>
    <body>
    <h1>I’m DevOps Engineer!</h1>
    </body>
    </html>
### Задача 2
Посмотрите на сценарий ниже и ответьте на вопрос: "Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

#### Сценарий:
- Высоконагруженное монолитное java веб-приложение;
######
    Физическая или виртуальная машина т.к. требуется прямой доступ к ресурсам. Крутится множество сервисов в контейнерах.
- Nodejs веб-приложение;
######
    Docker контейнер. Это вэб-приложение с подключаемыми библиотеками.
- Мобильное приложение c версиями для Android и iOS;
######
    Виртуальная машина.
- Шина данных на базе Apache Kafka;
######
    Брокер сообщений не требует больших ресурсов и для надежности лучше использовать виртуальную машину.
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
######
    Виртуальная машина. настройка кластера. Logstash и Kibana можно развернуть в Docker.
- Мониторинг-стек на базе Prometheus и Grafana;
######
    Можно использовать Docker.
- MongoDB, как основное хранилище данных для java-приложения;
######
    Зависит от нагрузки на базу данных. Виртуальная машина или физическая.
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
######
    Виртуальная машина.

### Задача 3
- Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера;
######
    root@test:~# docker run -it --rm -d --name centos -v $(pwd)/data:/data centos:latest
    Unable to find image 'centos:latest' locally
    latest: Pulling from library/centos
    a1d0c7532777: Pull complete 
    Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
    Status: Downloaded newer image for centos:latest
    4578b695385dfb8a8987a3821766843fd1d0aafc247cfe80d91aafbb6a7a6c14

    root@test:~# docker ps
    CONTAINER ID   IMAGE           COMMAND       CREATED          STATUS          PORTS     NAMES
    4578b695385d   centos:latest   "/bin/bash"   46 seconds ago   Up 45 seconds             centos
- апустите второй контейнер из образа debian в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера;
######
    root@test:~# docker run -it --rm -d --name debian -v $(pwd)/data:/data debian:latest      
    Unable to find image 'debian:latest' locally
    latest: Pulling from library/debian
    bbeef03cda1f: Pull complete 
    Digest: sha256:534da5794e770279c889daa891f46f5a530b0c5de8bfbc5e40394a0164d9fa87
    Status: Downloaded newer image for debian:latest
    62e4809d10f7764734690c8c41c192ffdfdc32991bb51e9a3b9a03dd29392bd

    root@test:~# docker ps
    CONTAINER ID   IMAGE           COMMAND       CREATED         STATUS         PORTS     NAMES
    62e4809d10f7   debian:latest   "bash"        4 seconds ago   Up 2 seconds             debian
    4578b695385d   centos:latest   "/bin/bash"   3 minutes ago   Up 3 minutes             centos
- Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data;
######
    root@test:~# docker exec -it centos /bin/bash
    [root@4578b695385d /]# echo 'TEST_TEST' >> /data/test.txt
    [root@4578b695385d /]# exit
    exit
- Добавьте еще один файл в папку /data на хостовой машине;
######
    root@test:~# echo 'TEST2_TEST2' >> data/test2.txt
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.
######
    root@test:~# docker exec -it debian /bin/bash
    root@62e4809d10f7:/# ls -la /data/
    total 16
    drwxr-xr-x 2 root root 4096 Jan 25 09:36 .
    drwxr-xr-x 1 root root 4096 Jan 25 09:12 ..
    -rw-r--r-- 1 root root   10 Jan 25 09:31 test.txt
    -rw-r--r-- 1 root root   12 Jan 25 09:36 test2.txt
### Задача 4 (*)
#### Воспроизвести практическую часть лекции самостоятельно.
#### Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.
