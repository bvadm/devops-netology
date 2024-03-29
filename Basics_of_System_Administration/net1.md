### Домашнее задание к занятию "3.6. Компьютерные сети. Лекция 1"
#### 1. Работа c HTTP через телнет.
 + Подключитесь утилитой телнет к сайту stackoverflow.com telnet stackoverflow.com 80
 + Отправьте HTTP запрос
####
    GET /questions HTTP/1.0 
    HOST: stackoverflow.com
    [press enter]
    [press enter]
####
    vagrant@vagrant:~$ telnet stackoverflow.com 80
    Trying 151.101.193.69...
    Connected to stackoverflow.com.
    Escape character is '^]'.
    GET /questions HTTP/1.0
    HOST: stackoverflow.com

    HTTP/1.1 403 Forbidden
    Connection: close
    Content-Length: 1920
    Server: Varnish
    Retry-After: 0
    Content-Type: text/html
    Accept-Ranges: bytes
    Date: Fri, 25 Nov 2022 10:12:21 GMT
    Via: 1.1 varnish
    X-Served-By: cache-fra-eddf8230089-FRA
    X-Cache: MISS
    X-Cache-Hits: 0
    X-Timer: S1669371141.483510,VS0,VE2
    X-DNS-Prefetch-Control: off

    <!DOCTYPE html>
    <html>
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Forbidden - Stack Exchange</title>
    <style type="text/css">
                body
                {
                        color: #333;
                        font-family: 'Helvetica Neue', Arial, sans-serif;
                        font-size: 14px;
                        background: #fff url('img/bg-noise.png') repeat left top;
                        line-height: 1.4;
                }
                h1
                {
                        font-size: 170%;
                        line-height: 34px;
                        font-weight: normal;
                }
                a { color: #366fb3; }
                a:visited { color: #12457c; }
                .wrapper {
                        width:960px;
                        margin: 100px auto;
                        text-align:left;
                }
                .msg {
                        float: left;
                        width: 700px;
                        padding-top: 18px;
                        margin-left: 18px;
                }
    </style>
    </head>
    <body>
    <div class="wrapper">
                <div style="float: left;">
                        <img src="https://cdn.sstatic.net/stackexchange/img/apple-touch-icon.png" alt="Stack Exchange" />
                </div>
                <div class="msg">
                        <h1>Access Denied</h1>
                        <p>This IP address (212.49.110.58) has been blocked from access to our services. If you believe this to be in error, please contact us at <a href="mailto:team@stackexchange.com?Subject=Blocked%20212.49.110.58%20(Request%20ID%3A%202624053284-FRA)">team@stackexchange.com</a>.</p>
                        <p>When contacting us, please include the following information in the email:</p>
                        <p>Method: block</p>
                        <p>XID: 2624053284-FRA</p>
                        <p>IP: 212.49.110.58</p>
                        <p>X-Forwarded-For: </p>
                        <p>User-Agent: </p>

                        <p>Time: Fri, 25 Nov 2022 10:12:21 GMT</p>
                        <p>URL: stackoverflow.com/questions</p>
                        <p>Browser Location: <span id="jslocation">(not loaded)</span></p>
                </div>
        </div>
        <script>document.getElementById('jslocation').innerHTML = window.location.href;</script>
    </body>
    </html>Connection closed by foreign host.
#### В ответе укажите полученный HTTP код, что он означает?
#### Получил ответ 403 Forbidden. Ограничение в доступе.

### 2. Повторите задание 1 в браузере, используя консоль разработчика F12.
+ откройте вкладку Network
+ отправьте запрос http://stackoverflow.com
+ найдите первый ответ HTTP сервера, откройте вкладку Headers
+ укажите в ответе полученный HTTP код
+ проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
+ приложите скриншот консоли браузера в ответ.
####
![](net1-pic1.jpg)
#### Получил код 307. Редирект.
![](net1-pic2.jpg)
#### Страница загрузилась полностью за 488мс. Самый долгий запрос выполнялся 339мс.
![](net1-pic3.jpg)


#### 3. Какой IP адрес у вас в интернете?
    $ dig +short myip.opendns.com @resolver1.opendns.com
    212.49.xxx.xxx

#### 4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой whois
    $ whois 212.49.xxx.xxx | grep descr
    descr:          LLC KOMTEHCENTR FTTB Customers

    $ whois 212.49.xxx.xxx | grep origin
    origin:         AS12668

#### 5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой traceroute
    $ traceroute -A -n 8.8.8.8
    traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
    1  * * *
    2  192.168.151.1 [*]  0.608 ms  0.599 ms  0.595 ms
    3  212.49.xxx.xxx [AS12668]  1.555 ms  1.681 ms  1.746 ms
    4  92.242.29.74 [AS12668]  5.043 ms  6.325 ms  8.908 ms
    5  212.188.22.34 [AS8359]  2.436 ms  2.136 ms  2.426 ms
    6  212.188.22.33 [AS8359]  1.806 ms  1.874 ms  1.833 ms
    7  * * *
    8  * 212.188.29.85 [AS8359]  30.988 ms  30.986 ms
    9  * * *
    10  212.188.54.213 [AS8359]  30.587 ms  30.840 ms  30.707 ms
    11  72.14.211.222 [AS15169]  30.872 ms  31.169 ms 209.85.149.166 [AS15169]  29.517 ms
    12  * * *
    13  108.170.250.33 [AS15169]  29.990 ms 172.253.69.166 [AS15169]  30.353 ms 108.170.250.33 [AS15169]  31.006 ms
    14  108.170.250.83 [AS15169]  32.672 ms 108.170.250.34 [AS15169]  31.169 ms 108.170.250.146 [AS15169]  33.165 ms
    15  142.251.49.78 [AS15169]  42.217 ms 172.253.66.116 [AS15169]  51.818 ms 142.251.49.78 [AS15169]  41.994 ms
    16  142.250.235.74 [AS15169]  48.395 ms 72.14.232.76 [AS15169]  48.429 ms 172.253.66.110 [AS15169]  38.881 ms
    17  172.253.79.237 [AS15169]  44.506 ms 172.253.79.169 [AS15169]  49.768 ms 108.170.233.161 [AS15169]  49.524 ms
    26  * * *
    27  8.8.8.8 [AS15169]  43.582 ms *  43.486 ms
#### Пакет проходит через AS12668, AS8359, AS15169

#### 6. Повторите задание 5 в утилите mtr. На каком участке наибольшая задержка - delay?
    $ mtr 8.8.8.8 -znr
    Start: 2022-11-24T16:46:48+0500
    HOST: sysms                       Loss%   Snt   Last   Avg  Best  Wrst StDev
    1. AS???    ???                 100.0    10    0.0   0.0   0.0   0.0   0.0
    2. AS???    192.168.151.1        0.0%    10    0.6   0.5   0.5   0.7   0.1
    3. AS12668  212.49.xx.xx        0.0%    10    1.3   2.0   1.1   4.5   1.2
    4. AS12668  92.242.29.74         0.0%    10    3.5   4.8   2.4   8.5   1.9
    5. AS8359   212.188.22.34        0.0%    10    2.1   2.1   2.0   2.3   0.1
    6. AS8359   212.188.22.33        0.0%    10   17.0   3.4   1.7  17.0   4.8
    7. AS8359   212.188.29.249      90.0%    10    2.2   2.2   2.2   2.2   0.0
    8. AS8359   212.188.29.85       80.0%    10   31.5  31.4  31.2  31.5   0.2
    9. AS???    ???                 100.0    10    0.0   0.0   0.0   0.0   0.0
    10. AS8359   212.188.54.213       0.0%    10   30.9  31.0  30.7  31.5   0.3
    11. AS15169  209.85.149.166       0.0%    10   29.7  29.7  29.4  30.0   0.2
    12. AS15169  172.253.68.11        0.0%    10   30.1  30.6  30.1  30.9   0.3
    13. AS15169  108.170.250.83      10.0%    10   29.7  36.8  29.1  70.3  13.7
    14. AS15169  142.250.239.64       0.0%    10   41.3  41.6  41.2  42.2   0.3
    15. AS15169  74.125.253.109       0.0%    10   42.8  43.0  42.1  47.4   1.6
    16. AS15169  172.253.51.249       0.0%    10   45.6  45.4  45.2  45.8   0.2
    25. AS???    ???                 100.0    10    0.0   0.0   0.0   0.0   0.0
    26. AS15169  8.8.8.8              0.0%    10   43.8  44.1  43.8  44.3   0.2
#### Наибольшая задержка на 16 прыжке.

### 7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? Воспользуйтесь утилитой dig
    $ dig +short NS dns.google
    ns1.zdns.google.
    ns4.zdns.google.
    ns3.zdns.google.
    ns2.zdns.google.
    216.239.32.114
    2001:4860:4802:32::72
    216.239.38.114
    2001:4860:4802:38::72
    216.239.36.114
    2001:4860:4802:36::72
    216.239.34.114
    2001:4860:4802:34::72
    
    $ dig +short A dns.google
    8.8.8.8
    8.8.4.4

#### 8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? Воспользуйтесь утилитой dig
    $ for ip in `dig +short A dns.google`; do dig -x $ip | grep ^[0-9].*in-addr.arpa; done
    4.4.8.8.in-addr.arpa.   0       IN      PTR     dns.google.
    8.8.8.8.in-addr.arpa.   0       IN      PTR     dns.google.