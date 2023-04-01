## Домашнее задание к занятию 5. «Elasticsearch»
### Задача 1
#### В этом задании вы потренируетесь в:
+ установке Elasticsearch,
+ первоначальном конфигурировании Elasticsearch,
+ запуске Elasticsearch в Docker.
#### Используя Docker-образ centos:7 как базовый и документацию по установке и запуску Elastcisearch:
+ составьте Dockerfile-манифест для Elasticsearch,
+ соберите Docker-образ и сделайте push в ваш docker.io-репозиторий,
+ запустите контейнер из получившегося образа и выполните запрос пути / c хост-машины.
#### Требования к elasticsearch.yml:
+ данные path должны сохраняться в /var/lib,
+ имя ноды должно быть netology_test.
#### В ответе приведите:
+ текст Dockerfile-манифеста,
####
    FROM centos:7

    USER 0

    RUN yum install wget -y && \
        wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.0-linux-x86_64.tar.gz && \
        wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.0-linux-x86_64.tar.gz.sha512 && \
        sha512sum -c elasticsearch-7.17.0-linux-x86_64.tar.gz.sha512 && \
        tar -xzf elasticsearch-7.17.0-linux-x86_64.tar.gz && \
        rm -f elasticsearch-7.17.0-linux-x86_64.tar.gz* && \
        mv elasticsearch-7.17.0 /var/lib/elasticsearch && \
        useradd -m -u 1000 elasticsearch && \
        chown -R elasticsearch: /var/lib/elasticsearch && \
        yum remove wget -y && \
        yum clean all

    COPY --chown=elasticsearch:elasticsearch config/* /var/lib/elasticsearch/config/

    USER 1000

    WORKDIR /var/lib/elasticsearch

    EXPOSE 9200

    CMD ["sh", "-c", "/var/lib/elasticsearch/bin/elasticsearch"]
+ ссылку на образ в репозитории dockerhub,
#### https://hub.docker.com/r/bvadm/elasticsearch/tags
+ ответ Elasticsearch на запрос пути / в json-виде.
####
    root@test:~/netology/elasticsearch# curl -X GET "localhost:9200/"                      
    {
      "name" : "netology_test",
      "cluster_name" : "elasticsearch",
      "cluster_uuid" : "69ytHuXpTSC18g3lnLra0w",
      "version" : {
        "number" : "7.17.0",
        "build_flavor" : "default",
        "build_type" : "tar",
        "build_hash" : "bee86328705acaa9a6daede7140defd4d9ec56bd",
        "build_date" : "2022-01-28T08:36:04.875279988Z",
        "build_snapshot" : false,
        "lucene_version" : "8.11.1",
        "minimum_wire_compatibility_version" : "6.8.0",
        "minimum_index_compatibility_version" : "6.0.0-beta1"
      },
      "tagline" : "You Know, for Search"
    }
#### Подсказки:
+ возможно, вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum,
+ при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml,
+ при некоторых проблемах вам поможет Docker-директива ulimit,
+ Elasticsearch в логах обычно описывает проблему и пути её решения.
#### Далее мы будем работать с этим экземпляром Elasticsearch.

### Задача 2
#### В этом задании вы научитесь:
+ создавать и удалять индексы,
+ изучать состояние кластера,
+ обосновывать причину деградации доступности данных.
#### Ознакомьтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) и добавьте в Elasticsearch 3 индекса в соответствии с таблицей:
| Имя   | Количество реплик | Количество шард |
|-------|-------------------|-----------------|
| ind-1 | 0                 | 1               |
| ind-2 | 1                 | 2               |
| ind-3 | 2                 | 4               |

    curl -X PUT "localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'
    > {
    > "settings" : {
    > "index" : {
    > "number_of_shards" : 1,
    > "number_of_replicas" : 0
    > }
    > }
    > }'
    {
      "acknowledged" : true,
      "shards_acknowledged" : true,
      "index" : "ind-1"
    }

    curl -X PUT "localhost:9200/ind-2?pretty" -H 'Content-Type: application/json' -d'
    > { 
    > "settings" : {
    > "index" : {
    > "number_of_shards" : 2,
    > "number_of_replicas" : 1
    > }
    > }
    > }'
    {
      "acknowledged" : true,
      "shards_acknowledged" : true,
      "index" : "ind-2"
    }

    curl -X PUT "localhost:9200/ind-3?pretty" -H 'Content-Type: application/json' -d'
    > {
    > "settings" : {
    > "index" : {
    > "number_of_shards" : 4,
    > "number_of_replicas" : 3
    > }
    > }
    > }'
    {
      "acknowledged" : true,
      "shards_acknowledged" : true,
      "index" : "ind-3"
    }
#### Получите список индексов и их статусов, используя API, и приведите в ответе на задание.
    root@test:~# curl -X GET "http://localhost:9200/_cat/indices?pretty"
    green  open .geoip_databases 4awjvqqTTv-qQhACn61Vsw 1 0 42 39 40.4mb 40.4mb
    green  open ind-1            NWqi9n25RBmtiMG0Chc1mQ 1 0  0  0   226b   226b
    yellow open ind-3            33f7Y4BMQwuvZce-mlbX6g 4 2  0  0   904b   904b
    yellow open ind-2            EB5YsS1sTxO4Mf61iKVhGw 2 1  0  0   452b   452b
#### Получите состояние кластера Elasticsearch, используя API.
    root@test:~# curl -X GET "localhost:9200/_cluster/health?pretty"
    {
      "cluster_name" : "elasticsearch",
      "status" : "yellow",
      "timed_out" : false,
      "number_of_nodes" : 1,
      "number_of_data_nodes" : 1,
      "active_primary_shards" : 10,
      "active_shards" : 10,
      "relocating_shards" : 0,
      "initializing_shards" : 0,
      "unassigned_shards" : 10,
      "delayed_unassigned_shards" : 0,
      "number_of_pending_tasks" : 0,
      "number_of_in_flight_fetch" : 0,
      "task_max_waiting_in_queue_millis" : 0,
      "active_shards_percent_as_number" : 50.0
    }
#### Как вы думаете, почему часть индексов и кластер находятся в состоянии yellow?
#### Потому что у меня запущена одна нода и соответственно негде размещать реплику.
#### Удалите все индексы.
    curl -X DELETE "http://localhost:9200/ind-1?pretty"
    curl -X DELETE "http://localhost:9200/ind-2?pretty"
    curl -X DELETE "http://localhost:9200/ind-3?pretty"
    или по маске. Должен быть параметр 'action.destructive_requires_name: false' в elasticsearch.yml
    curl -X DELETE 'http://localhost:9200/ind*'
    
### Задача 3
#### В этом задании вы научитесь:
+ создавать бэкапы данных,
+ восстанавливать индексы из бэкапов.
#### Создайте директорию {путь до корневой директории с Elasticsearch в образе}/snapshots.
    root@test:~# docker exec -it -u root elasticsearch bash
    [root@af4683d1e617 elasticsearch]# mkdir snapshots
    [root@af4683d1e617 elasticsearch]# chown elasticsearch: snapshots/
    [root@af4683d1e617 elasticsearch]# echo path.repo: "/var/lib/elasticsearch/snapshots" >> "config/elasticsearch.yml"
#### Используя API, [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) эту директорию как snapshot repository c именем netology_backup.
    root@test:~# curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
    > {
    > "type": "fs",
    > "settings": {
    > "location": "/var/lib/elasticsearch/snapshots",
    > "compress": true
    > }
    > }'
    {
      "acknowledged" : true
    }
#### Приведите в ответе запрос API и результат вызова API для создания репозитория.
    root@test:~# curl -X GET "localhost:9200/_snapshot/netology_backup?pretty"
    
    {
      "netology_backup" : {
        "type" : "fs",
        "uuid" : "t9K4HVPlQ7KZz08UeBzMqA",
        "settings" : {
          "compress" : "true",
          "location" : "/var/lib/elasticsearch/snapshots"
        }
      }
    }
#### Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.
    root@test:~# curl -X PUT "localhost:9200/test?pretty" -H 'Content-Type: application/json' -d'
    > {
    > "settings" : {
    > "index" : {
    > "number_of_shards" : 1,
    > "number_of_replicas" : 0
    > }
    > }
    > }'
    {
      "acknowledged" : true,
      "shards_acknowledged" : true,
      "index" : "test"
    }

    root@test:~# curl -X GET "http://localhost:9200/_cat/indices?pretty"                         
    green open .geoip_databases UJvQEyYLRKW8ajKe8KCkYQ 1 0 42 0 40.5mb 40.5mb
    green open test             4kYmxxGeTbCj7P9uCH8eaQ 1 0  0 0   226b   226b
#### [Создайте snapshot](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) состояния кластера Elasticsearch.
    root@test:~# curl -X PUT "localhost:9200/_snapshot/netology_backup/snapshot_1?wait_for_completion=true&pretty"    
    {
      "snapshot" : {
        "snapshot" : "snapshot_1",
        "uuid" : "7bpwWb5OQyqcN5og1Bllww",
        "repository" : "netology_backup",
        "version_id" : 7170099,
        "version" : "7.17.0",
        "indices" : [
          ".geoip_databases",
          "test",
          ".ds-ilm-history-5-2023.04.01-000001",
          ".ds-.logs-deprecation.elasticsearch-default-2023.04.01-000001"
        ],
        "data_streams" : [
          "ilm-history-5",
          ".logs-deprecation.elasticsearch-default"
        ],
        "include_global_state" : true,
        "state" : "SUCCESS",
        "start_time" : "2023-04-01T10:39:08.417Z",
        "start_time_in_millis" : 1680345548417,
        "end_time" : "2023-04-01T10:39:09.618Z",
        "end_time_in_millis" : 1680345549618,
        "duration_in_millis" : 1201,
        "failures" : [ ],
        "shards" : {
          "total" : 4,
          "failed" : 0,
          "successful" : 4
        },
        "feature_states" : [
          {
            "feature_name" : "geoip",
            "indices" : [
              ".geoip_databases"
            ]
          }
        ]
      }
    }
#### Приведите в ответе список файлов в директории со snapshot.
    root@test:~# docker exec -it elasticsearch ls -la /var/lib/elasticsearch/snapshots 
    total 40
    drwxr-xr-x 3 elasticsearch elasticsearch 4096 Apr  1 09:33 .
    drwxr-xr-x 1 elasticsearch elasticsearch 4096 Apr  1 09:07 ..
    -rw-r--r-- 1 elasticsearch elasticsearch 1422 Apr  1 09:33 index-0
    -rw-r--r-- 1 elasticsearch elasticsearch    8 Apr  1 09:33 index.latest
    drwxr-xr-x 6 elasticsearch elasticsearch 4096 Apr  1 09:33 indices
    -rw-r--r-- 1 elasticsearch elasticsearch 9715 Apr  1 09:33 meta-Y546qj4MSGCmFGq2m8IFhg.dat
    -rw-r--r-- 1 elasticsearch elasticsearch  455 Apr  1 09:33 snap-Y546qj4MSGCmFGq2m8IFhg.dat
#### Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов.
    root@test:~# curl -X DELETE "http://localhost:9200/test?pretty" 
    {
      "acknowledged" : true
    }

    root@test:~# curl -X PUT "localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d'
    > {
    > "settings" : {
    > "index" : {
    > "number_of_shards" : 1,
    > "number_of_replicas" : 0
    > }
    > }
    > }'
    {
      "acknowledged" : true,
      "shards_acknowledged" : true,
      "index" : "test-2"
    }

    root@test:~# curl -X GET "http://localhost:9200/_cat/indices?pretty"
    green open test-2           nGADk5n5SGy7SFU1k45D3w 1 0  0 0   226b   226b
    green open .geoip_databases sdJ08Fz3Q-Kvo_u91HR99g 1 0 42 0 40.5mb 40.5mb
#### Восстановите состояние кластера Elasticsearch из snapshot, созданного ранее.
#### Приведите в ответе запрос к API восстановления и итоговый список индексов.
######    Ошибка восстановления. Имеется открытый индекс с таким же именем. Закрыл индекс.
    root@test:~# curl -X POST "localhost:9200/_snapshot/netology_backup/snapshot_1/_restore?pretty" -H 'Content-Type: application/json' -d'
    > {
    > "indices": "*",
    > "include_global_state": true
    > }'
    {
      "error" : {
        "root_cause" : [
          {
            "type" : "snapshot_restore_exception",
            "reason" : "[netology_backup:snapshot_1/7bpwWb5OQyqcN5og1Bllww] cannot restore index [.ds-.logs-deprecation.elasticsearch-default-2023.04.01-000001] because an open index with same name already exists in the cluster. Either close or delete the existing index or restore the index under a different name by providing a rename pattern and replacement name"
          }
        ],
        "type" : "snapshot_restore_exception",
        "reason" : "[netology_backup:snapshot_1/7bpwWb5OQyqcN5og1Bllww] cannot restore index [.ds-.logs-deprecation.elasticsearch-default-2023.04.01-000001] because an open index with same name already exists in the cluster. Either close or delete the existing index or restore the index under a different name by providing a rename pattern and replacement name"
      },
      "status" : 500
    }
###### Закрыл интекс
    root@test:~# curl -X POST "localhost:9200/.ds-.logs-deprecation.elasticsearch-default-2023.04.01-000001/_close?pretty"
    {
      "acknowledged" : true,
      "shards_acknowledged" : true,
      "indices" : {
        ".ds-.logs-deprecation.elasticsearch-default-2023.04.01-000001" : {
          "closed" : true
        }
      }
    }
###### Ошибка
    root@test:~# curl -X POST "localhost:9200/_snapshot/netology_backup/snapshot_1/_restore?pretty" -H 'Content-Type: application/json' -d'
    {
    "indices": "*",
    "include_global_state": true
    }'
    {
      "error" : {
        "root_cause" : [
          {
            "type" : "snapshot_restore_exception",
            "reason" : "[netology_backup:snapshot_1/7bpwWb5OQyqcN5og1Bllww] cannot restore index [.ds-ilm-history-5-2023.04.01-000001] because an open index with same name already exists in the cluster. Either close or delete the existing index or restore the index under a different name by providing a rename pattern and replacement name"
          }
        ],
        "type" : "snapshot_restore_exception",
        "reason" : "[netology_backup:snapshot_1/7bpwWb5OQyqcN5og1Bllww] cannot restore index [.ds-ilm-history-5-2023.04.01-000001] because an open index with same name already exists in the cluster. Either close or delete the existing index or restore the index under a different name by providing a rename pattern and replacement name"
      },
      "status" : 500
    }
###### Закрыл индекс 
    root@test:~# curl -X POST "localhost:9200/.ds-ilm-history-5-2023.04.01-000001/_close?pretty"                                           
    {
      "acknowledged" : true,
      "shards_acknowledged" : true,
      "indices" : {
        ".ds-ilm-history-5-2023.04.01-000001" : {
          "closed" : true
        }
      }
    }
#### Восстановление
    root@test:~# curl -X POST "localhost:9200/_snapshot/netology_backup/snapshot_1/_restore?pretty" -H 'Content-Type: application/json' -d'
    {
      "indices": "*",
      "include_global_state": true
    }
    '
    {
      "accepted" : true
    }

    root@test:~# curl -X GET "http://localhost:9200/_cat/indices?pretty"                                                                   
    green open test-2           nGADk5n5SGy7SFU1k45D3w 1 0  0 0   226b   226b
    green open .geoip_databases C3CfaasvRbKbXAV4klTaFA 1 0 42 0 40.5mb 40.5mb
    green open test             1nyrtbo6QT2BHs7OoF7yOg 1 0  0 0   226b   226b
