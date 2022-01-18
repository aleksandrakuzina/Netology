### 1.Работа c HTTP через телнет. Подключитесь утилитой телнет к сайту stackoverflow.com telnet stackoverflow.com 80 отправьте HTTP запрос
> GET /questions HTTP/1.0
> HOST: stackoverflow.com
> [press enter]
> [press enter]
### В ответе укажите полученный HTTP код, что он означает?

````
telnet stackoverflow.com 80
Trying 151.101.1.69...
Connected to stackoverflow.com.
Escape character is '^]'.
GET /questions HTTP/1.0
HOST: stackoverflow.com

HTTP/1.1 301 Moved Permanently
cache-control: no-cache, no-store, must-revalidate
location: https://stackoverflow.com/questions
x-request-guid: db90ff9a-5eae-4f3e-93cb-52f0103ce5cb
feature-policy: microphone 'none'; speaker 'none'
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
Accept-Ranges: bytes
Date: Fri, 14 Jan 2022 14:27:48 GMT
Via: 1.1 varnish
Connection: close
X-Served-By: cache-hel1410034-HEL
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1642170468.490158,VS0,VE117
Vary: Fastly-SSL
X-DNS-Prefetch-Control: off
Set-Cookie: prov=b930f98a-2908-b7b7-0c6c-cb0975b90245; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly

Connection closed by foreign host.
````

*HTTP/1.1 301 Moved Permanently - означает что эта страница перемещена и переброс будет произведен по https://stackoverflow.com/questions.
Данная страница не кэшируется и кэш расчитывается заново при каждом соединении.*

### 2.Повторите задание 1 в браузере, используя консоль разработчика F12.
* откройте вкладку Network 
* отправьте запрос http://stackoverflow.com
* найдите первый ответ HTTP сервера, откройте вкладку Headers 
* укажите в ответе полученный HTTP код.  
* Полученный HTTP код 301 проверьте время загрузки страницы, какой запрос обрабатывался дольше всего? Запрос redirect 301 обрабатывался дольше всего. 
* приложите скриншот консоли браузера в ответ.

### 3.Какой IP адрес у вас в интернете?
212.45.0.44
### 4.Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой whois
```
descr:          comcor.ru
origin:         AS8732
```
### 5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой traceroute
````
 1  _gateway (10.0.0.1) [*]  0.215 ms  0.282 ms  0.456 ms
 2  192.168.0.99 (192.168.0.99) [*]  0.865 ms  0.763 ms  0.743 ms
 3  comcor-inet.comcor.ru (212.45.0.62) [AS8732]  3.999 ms  3.919 ms  3.899 ms
 4  mx10k3-vlad-acx-vlad.comcor.ru (62.117.100.163) [AS8732]  2.566 ms  2.760 ms  2.855 ms
 5  72.14.194.74 (72.14.194.74) [AS15169]  3.750 ms  3.743 ms  3.733 ms
 6  108.170.250.130 (108.170.250.130) [AS15169]  4.765 ms 108.170.250.66 (108.170.250.66) [AS15169]  3.338 ms 108.170.250.51 (108.170.250.51) [AS15169]  2.814 ms
 7  142.251.49.24 (142.251.49.24) [AS15169]  19.680 ms 209.85.255.136 (209.85.255.136) [AS15169]  18.177 ms 142.251.49.24 (142.251.49.24) [AS15169]  18.489 ms
 8  172.253.65.82 (172.253.65.82) [AS15169]  17.488 ms 108.170.235.64 (108.170.235.64) [AS15169]  18.991 ms 74.125.253.109 (74.125.253.109) [AS15169]  15.230 ms
 9  142.250.209.35 (142.250.209.35) [AS15169]  19.074 ms 142.250.210.45 (142.250.210.45) [AS15169]  17.702 ms 216.239.58.67 (216.239.58.67) [AS15169]  19.610 ms
10  * * *
11  * * *
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * dns.google (8.8.8.8) [AS15169]  15.046 ms
````

### 6. Повторите задание 5 в утилите mtr. На каком участке наибольшая задержка - delay?
*На между 9-м и 8-м хопами фиксируется самое высокое среднее время задержки (AVG 18.2 - 20.9)*

````
 # mtr -r -c 10 8.8.8.8
Start: 2022-01-14T18:11:44+0300
HOST: debian                      Loss%   Snt   Last   Avg  Best  Wrst StDev
  1.|-- _gateway                   0.0%    10    0.4   0.4   0.3   0.4   0.0
  2.|-- 192.168.0.99               0.0%    10    0.8   0.8   0.7   0.9   0.1
  3.|-- comcor-inet.comcor.ru      0.0%    10    2.5   3.4   2.4   5.8   1.3
  4.|-- mx10k3-vlad-acx-vlad.comc  0.0%    10    2.6   2.9   2.3   5.3   0.9
  5.|-- 72.14.194.74               0.0%    10    5.8   6.8   2.9  16.1   4.6
  6.|-- 108.170.250.66             0.0%    10    3.3   3.4   3.2   3.7   0.1
  7.|-- 209.85.255.136            20.0%    10   18.1  18.4  17.9  20.5   0.9
  8.|-- 172.253.65.82              0.0%    10   17.9  18.2  17.3  24.4   2.2
  9.|-- 172.253.70.47              0.0%    10   21.0  20.9  20.7  21.2   0.2
 10.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
 11.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
 12.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
 13.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
 14.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
 15.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
 16.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
 17.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
 18.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
 19.|-- dns.google                10.0%    10   18.4  19.1  17.6  20.0   1.1
```` 

### 7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой dig

````
dig  dns.google A NS
;; Warning, extra type option

; <<>> DiG 9.11.5-P4-5.1+deb10u6-Debian <<>> dns.google A NS
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 55698
;; flags: qr rd ra; QUERY: 1, ANSWER: 4, AUTHORITY: 0, ADDITIONAL: 9

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 1cbfd3fcae6efa714dc158fc61e193f6f52131cc734dc0dd (good)
;; QUESTION SECTION:
;dns.google.                    IN      NS

;; ANSWER SECTION:
dns.google.             7071    IN      NS      ns4.zdns.google.
dns.google.             7071    IN      NS      ns3.zdns.google.
dns.google.             7071    IN      NS      ns1.zdns.google.
dns.google.             7071    IN      NS      ns2.zdns.google.

;; ADDITIONAL SECTION:
ns1.zdns.google.        345559  IN      A       216.239.32.114
ns3.zdns.google.        345559  IN      A       216.239.36.114
ns4.zdns.google.        345559  IN      A       216.239.38.114
ns2.zdns.google.        345559  IN      A       216.239.34.114
ns1.zdns.google.        345559  IN      AAAA    2001:4860:4802:32::72
ns3.zdns.google.        345559  IN      AAAA    2001:4860:4802:36::72
ns4.zdns.google.        345559  IN      AAAA    2001:4860:4802:38::72
ns2.zdns.google.        345559  IN      AAAA    2001:4860:4802:34::72

;; Query time: 20 msec
;; SERVER: 212.45.0.3#53(212.45.0.3)
;; WHEN: Fri Jan 14 18:30:17 MSK 2022
;; MSG SIZE  rcvd: 326

````

### 8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой dig

dig -x 216.239.32.114
ns1.zdns.google.

dig -x 216.239.36.114
ns3.zdns.google.

dig -x 216.239.38.114
ns4.zdns.google.

dig -x 216.239.34.114
ns2.zdns.google.

````
# dig -x 216.239.34.114

; <<>> DiG 9.11.5-P4-5.1+deb10u6-Debian <<>> -x 216.239.34.114
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 1418
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 85e359f50aa073a3b047b06b61e1973d63c80e6a131fe57e (good)
;; QUESTION SECTION:
;114.34.239.216.in-addr.arpa.   IN      PTR

;; ANSWER SECTION:
114.34.239.216.in-addr.arpa. 86181 IN   PTR     ns2.zdns.google.

;; Query time: 2 msec
;; SERVER: 212.45.0.3#53(212.45.0.3)
;; WHEN: Fri Jan 14 18:44:17 MSK 2022
;; MSG SIZE  rcvd: 113

````