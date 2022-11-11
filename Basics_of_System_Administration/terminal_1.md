### 1. Установите средство виртуализации Oracle VirtualBox.
  + Выполнено.
  
### 2. Установите средство автоматизации Hashicorp Vagrant.
  + Выполнено.
  
### 3. В вашем основном окружении подготовьте удобный для дальнейшей работы терминал.
####  Добавил текущее время и количество фоновых процессов
    PS1="\u@\h_\A_\j\w:$"
  #### Приглашение имеет вид
    vagrant@vagrant_07:44_0~:$
####
### 4. С помощью базового файла конфигурации запустите Ubuntu 20.04 в VirtualBox посредством Vagrant.
#### а) Создал папку для хранения конфигурации ВМ
#### б) Инициализировал
    vagrant init
#### в) Сохранил образ box-а с именем "ubuntu-20_04" в инициализированную папку.
#### г) Изменил файл Vagrantfile
#### c 
    Vagrant.configure("2") do |config|
    config.vm.box = "base"
    end
#### на
    Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu-20_04"
    end
#### д) Запустил ВМ
    vagrant up
    vagrant ssh
Выполнено.
  
### 5. По умолчанию виртуальной машине выделено 2 cpu, 1Gb RAM, 64Gb и Vodeo 4Mb.

### 6. Назначить ресурсы в Vagrantfile для ВМ можно опциями
    v.memory = "1024"
    v.cpus = "1"
  #### или опциями ВМ
    config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = "1"
    end
  
### 7. Команда vagrant ssh из директории, в которой содержится Vagrantfile, позволит вам оказаться внутри виртуальной машины без каких-либо дополнительных настроек.
    vagrant@vagrant:~$
Выполнено.

### 8. Знакомство с bash
  #### а) какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?
Переменная HISTFILESIZE - определяем максимальное число строк для хранения в файле. (Строка 792 в справке bash)
Переменная HISTSIZE - Определяет количество комманд которые нужно хранить. По умолчанию 500. (Строка 806 в справке bash)
  #### б) что делает директива ignoreboth в bash?
  +  ignoreboth заменяет две опции ignorespace (не сохраняет команды перед которыми пробел) и ignoredups (не сохраняет в истории одинаковые команды)
    
### 9. В каких сценариях использования применимы скобки {} и на какой строчке man bash это описано?
+ Фигурные скобки применяются для сокращения ввода комманд ну или объединения операторов. Проще говоря цикличное выполнение команд с подстановкой.
+ Пример создание паппок: mkdir dir{01..10}
    
### 10. С учётом ответа на предыдущий вопрос, как создать однократным вызовом touch 100000 файлов? Получится ли аналогичным образом создать 300000? Если нет, то почему?
  #### Удалось создать 110249 файлов
    touch file{01..110249}
  #### Создать большее количество файлов не удалось из-за длинного списка аргументов.
    
### 11. В man bash поищите по /\[\[. Что делает конструкция [[ -d /tmp ]]
  #### В этой конструкции проверяется существует ли директория /tmp. В данном случае возвращает инстину т.е. 0, директория существует.
    if [[ -d /tmp ]]
    then
     echo "Директория есть"
    else
     echo "Директории нет"
    fi

### 12. Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке
    mkdir /tmp/new_path_dir
    cp /bin/bash /tmp/new_path_dir  
    PATH=/tmp/new_path_dir/:$PATH
    type -a bash
    bash is /tmp/new_path_directory/bash
    bash is /usr/local/bin/bash
    bash is /bin/bash
  
### 13. Чем отличается планирование команд с помощью batch и at?
  #### at - выполняет задачу в заданное время. Выполняется однократно.
  #### batch - выполняет задачу во ремя низкой загруженности системы, в среднем ниже 1,5 загруженности системы.
  
### 14. Завершите работу виртуальной машины чтобы не расходовать ресурсы компьютера и/или батарею ноутбука.
    vagrant@vagrant_09:12_0~:$exit
    vagrant suspend