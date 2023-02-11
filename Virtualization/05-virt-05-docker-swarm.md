## Домашнее задание к занятию "5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"
## Задача 1
##### Дайте письменые ответы на следующие вопросы:
+ ### В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
##### В режиме replication сервисы могут быть запущены в нескольких экземплярах по необходимости.
##### В режиме global сервис должен работать на каждой ноде в единственном экземпляре.
+ ### Какой алгоритм выбора лидера используется в Docker Swarm кластере?
##### Используется алгоритм распределенного консенсуса Raft. Когда ноды не видят лидера они переходят в статус кандидата. Кандидат отправляет всем нодам запрос на голосование и большинством голосов выбирается лидер. 
+ ### Что такое Overlay Network?
##### Это внутренняя виртуальная сеть для демонов docker. Позволяет общаться сервисам кластера между собой.

## Задача 2
##### Создать ваш первый Docker Swarm кластер в Яндекс.Облаке
##### Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
    docker node ls

    ubuntu@node01:~$ sudo docker node ls
    ID                            HOSTNAME   STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
    6v7kc5jh7r54l3jicql4028o4 *   node01     Ready     Active         Leader           23.0.1
    zws36g31i8r53vdm3bko0welm     node02     Ready     Active         Reachable        23.0.1
    jfe828d2xrmy441amfgvfpe57     node03     Ready     Active         Reachable        23.0.1
    u814xg7rgkx7xowjvfh9v0rth     node04     Ready     Active                          23.0.1
    ye8893pybd1k2dxf7smf1x3da     node05     Ready     Active                          23.0.1
    ribf7h8u28qr4zpopkzhvt6ve     node06     Ready     Active                          23.0.1

## Задача 3
##### Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.
##### Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
    docker service ls

    ubuntu@node01:~$ sudo docker service ls
    ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
    29ftnk86ki8y   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0    
    r053wbrs45jp   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
    tplgqg0lr1l0   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest                         
    wjfskhavmyvk   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest                      
    s0ppshs2yoll   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4           
    oxrx4pq9m2sk   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0   
    qc0p9rd2oh4u   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0       
    3e64f595cmdx   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0     

## Задача 4 (*)
##### Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
##### см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
    docker swarm update --autolock=true
#####
    ubuntu@node01:~$ sudo docker swarm update --autolock=true
    Swarm updated.
    To unlock a swarm manager after it restarts, run the `docker swarm unlock`
    command and provide the following key:

        SWMKEY-1-qq8bjtKETK3bdZfRYYJ2Z6dDhxQKLLfoDAJ9mqQvcaA

    Please remember to store this key in a password manager, since without it you
    will not be able to restart the manager.

    ubuntu@node01:~$ sudo service docker restart

    ubuntu@node01:~$ sudo docker service ls     
    Error response from daemon: Swarm is encrypted and needs to be unlocked before it can be used. Please use "docker swarm unlock" to unlock it.

    ubuntu@node01:~$ docker swarm unlock
    permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/info": dial unix /var/run/docker.sock: connect: permission denied
    ubuntu@node01:~$ sudo !!
    sudo docker swarm unlock
    Please enter unlock key: 

    ubuntu@node01:~$ sudo docker service ls  
    ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
    29ftnk86ki8y   swarm_monitoring_alertmanager       replicated   0/1        stefanprodan/swarmprom-alertmanager:v0.14.0    
    r053wbrs45jp   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
    tplgqg0lr1l0   swarm_monitoring_cadvisor           global       5/5        google/cadvisor:latest                         
    wjfskhavmyvk   swarm_monitoring_dockerd-exporter   global       5/5        stefanprodan/caddy:latest                      
    s0ppshs2yoll   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4           
    oxrx4pq9m2sk   swarm_monitoring_node-exporter      global       5/5        stefanprodan/swarmprom-node-exporter:v0.16.0   
    qc0p9rd2oh4u   swarm_monitoring_prometheus         replicated   0/1        stefanprodan/swarmprom-prometheus:v2.5.0       
    3e64f595cmdx   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
##### Ключ --autolock блокирует ноду для присоединения к кластеру если она была перезапущена. Для разблокировки потребуется ввести ключ.
##### После ввода ключа происходит расшифровка журнала Draf с секретами.
##### Предотвращает доступ злоумышлинников к конфигурации, данным и секретам кластера.