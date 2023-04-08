## Домашнее задание к занятию "Введение в Terraform"
### Цель задания
1. Установить и настроить Terrafrom.
2. Научиться использовать готовый код.
### Чеклист готовности к домашнему заданию
1. Скачайте и установите актуальную версию terraform(не менее 1.3.7). Приложите скриншот вывода команды terraform --version
#####
    root@test:~# terraform --version
    Terraform v1.4.4
    on linux_amd64
2. Скачайте на свой ПК данный git репозиторий. Исходный код для выполнения задания расположен в директории 01/src.
#####
    Выполнено
3. Убедитесь, что в вашей ОС установлен docker
#####
    root@test:~# docker version
    Client: Docker Engine - Community
    Version:           23.0.2
    API version:       1.42
    ...
    Server: Docker Engine - Community
     Engine:
      Version:          23.0.2
      API version:      1.42 (minimum version 1.12)
### Задание 1
1. Перейдите в каталог src. Скачайте все необходимые зависимости, использованные в проекте.
#####
    terraform init
2. Изучите файл .gitignore. В каком terraform файле допустимо сохранить личную, секретную информацию?
#####
##### Ответ: в personal.auto.tfvars. Но лучше для этих целей создать отдельный файл с секретами.
##### Также файлы tfstate т.к. по мимо описания инфраструктуры в нём храниться и секретная информация.
3. Выполните код проекта. Найдите в State-файле секретное содержимое созданного ресурса random_password. Пришлите его в качестве ответа.
#####
    "result": "v0tSbL1dw5BVISGi"
4. Раскомментируйте блок кода, примерно расположенный на строчках 29-42 файла main.tf. Выполните команду terraform validate. Объясните в чем заключаются намеренно допущенные ошибки? Исправьте их.
#####
##### В первом блоке resource пропущено имя объекта
    resource "docker_image" "nginx" {
      name         = "nginx:latest"
      keep_locally = true
    }
##### Во втором блоке resource не верно указано имя объекта
    resource "docker_container" "nginx" {
      image = docker_image.nginx.image_id
      name  = "example_${random_password.random_string.result}"

      ports {
        internal = 80
        external = 8000
      }
    }
5. Выполните код. В качестве ответа приложите вывод команды docker ps
#####
    root@test:~/netology/terraform/01/src# docker ps
    CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                  NAMES
    de85a4714c2e   080ed0ed8312   "/docker-entrypoint.…"   25 seconds ago   Up 25 seconds   0.0.0.0:8000->80/tcp   example_v0tSbL1dw5BVISGi
6. Замените имя docker-контейнера в блоке кода на hello_world, выполните команду terraform apply -auto-approve. Объясните своими словами, в чем может быть опасность применения ключа -auto-approve ?
##### 
##### Ответ: Ключ -auto-approve автоматически подтвердит наши изменения в конфигурации инфраструктуры. Используется для автоматизации развертывания или обновления. Нужно быть аккуратным используя его т.к. могут быть печальные последствия изменений.
7. Уничтожьте созданные ресурсы с помощью terraform. Убедитесь, что все ресурсы удалены. Приложите содержимое файла terraform.tfstate.
#####
    cat terraform.tfstate
    {
      "version": 4,
      "terraform_version": "1.4.4",
      "serial": 13,
      "lineage": "50750d88-b95b-cb71-c9df-402ec1cadde3",
      "outputs": {},
      "resources": [],
      "check_results": null
    }
8. Объясните, почему при этом не был удален docker образ nginx:latest ?(Ответ найдите в коде проекта или документации)
#####
##### Ответ: В main.tf в блоке resource используемого образа нужно выставить ключ keep_localy = false. Тогда при уничтожении ресурсов удалиться и образ.
##### Но если данный образ уже используется другим контейнером, терраформ не сможет его удалить и покажет ошибку. Нужно будет руками удалять doker rm -f <container name>
