# Домашнее задание к занятию "3.9. Элементы безопасности информационных систем"
*Ссылка на ДЗ: https://github.com/netology-code/sysadm-homeworks/tree/devsys10/03-sysadmin-09-security*

### 1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.
### **Ответ:**
*Настроено:*

![Alt text](Задание_1_установить_bitwarden.png)

### 2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden аккаунт через Google authenticator OTP
### **Ответ:**
*Google authenticator установлен, код генерируется каждые 30 секунд, вход с помощью двухфакторной аутентификации выполнен (ввод пароля + код OTP)*
![Alt text](Задание_2_1.png)

![Alt text](Задание_2_2.png)

### 3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.
### **Ответ:**
Скорректировано задание 3
````
root@debian /etc/ssh# cat /etc/apache2/sites-enabled/default-ssl.conf
<VirtualHost *:443>
ServerName www.kuzina.com
DocumentRoot /var/www/html
SSLEngine on
SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
</VirtualHost>
````
````
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt -subj "/C=RU/ST=Moscow/L=Netology/O=DevSys_DPC_2_Kuzina/OU=Org/CN=www.kuzina.com"
````
![Alt text](Задание_3_1.png)

![Alt text](Задание_3_2.png)

![Alt text](Задание_3_5.png)

![Alt text](Задание_3_4.png)

![Alt text](Задание_3_3.png)

### 4. Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное).

![Alt text](tls.png)

![Alt text](tls_2.png)

### 5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.

 Скорректировано задание 5

*Передаем публичный ssh ключ в дебиан*
```
root@debian ~/.ssh# echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9ustRJdYxZqIJktG9zorl9WYfkaj0iSZXlVJOYPVPKve8qrTOVepqpL5C2of4AozM6Q0Ix0Kppz0VKS9uqj9JCFCYPZRQtPaU0gxhOt1i9C4iefFBVsHaQHvImyMWsPpeg3ThDVBZnclE/X9CQR5gT9RW0CrDFJzfiLfnUjSoaaz3dXcQurqo/ZVO6cbrZWWKMaNSkgmLKyQE55nh+TOYnE74ijVn8UJjkNoeOicpBTUGWa6ZIcXL7ag6wsiJcmUPPofxhbzlhB6gCa+3v6SQ92FfJRe9w+LVixuWgHoTFZ8RrBaSp14SFxprrwkZEQyfBR9uMZAxHZcxmnpGHrKel0bNnJMVrITzSnCCRB5t1VE2JbNhqhO5HL+ras8XOZz80Kj57K6E1hYb+OtdscnBPbNOtxa6Q+kwX+gjqGXqIJrmaD8iCnLI+hvUhX2cNzi5TZWt6UBhIEpMcly0o+krkXQfpWpHaShTaKi1+BrD9R+3fBW18uRkajZPY0b3lC0= sasha@DESKTOP-629HIOD" >> ~/.ssh/authorized_keys
```
*заходим по ключу из windows в дебиан*
```
C:\WINDOWS\system32>ssh -v  root@192.168.0.226
OpenSSH_for_Windows_8.1p1, LibreSSL 3.0.2
debug1: Connecting to 192.168.0.226 [192.168.0.226] port 22.
debug1: Connection established.
debug1: identity file C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/id_rsa type 0
debug1: identity file C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/id_rsa-cert type -1
debug1: identity file C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/id_dsa type -1
debug1: identity file C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/id_dsa-cert type -1
debug1: identity file C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/id_ecdsa type -1
debug1: identity file C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/id_ecdsa-cert type -1
debug1: identity file C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/id_ed25519 type -1
debug1: identity file C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/id_ed25519-cert type -1
debug1: identity file C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/id_xmss type -1
debug1: identity file C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/id_xmss-cert type -1
debug1: Local version string SSH-2.0-OpenSSH_for_Windows_8.1
debug1: Remote protocol version 2.0, remote software version OpenSSH_7.9p1 Debian-10+deb10u2
debug1: match: OpenSSH_7.9p1 Debian-10+deb10u2 pat OpenSSH* compat 0x04000000
debug1: Authenticating to 192.168.0.226:22 as 'root'
debug1: SSH2_MSG_KEXINIT sent
debug1: SSH2_MSG_KEXINIT received
debug1: kex: algorithm: curve25519-sha256
debug1: kex: host key algorithm: ecdsa-sha2-nistp256
debug1: kex: server->client cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: kex: client->server cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: expecting SSH2_MSG_KEX_ECDH_REPLY
debug1: Server host key: ecdsa-sha2-nistp256 SHA256:WgDgaAq5/f+OD/HQ4YIwpo4GnNzTHUePfAJSCrWzrNs
debug1: Host '192.168.0.226' is known and matches the ECDSA host key.
debug1: Found key in C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/known_hosts:1
debug1: rekey out after 134217728 blocks
debug1: SSH2_MSG_NEWKEYS sent
debug1: expecting SSH2_MSG_NEWKEYS
debug1: SSH2_MSG_NEWKEYS received
debug1: rekey in after 134217728 blocks
debug1: pubkey_prepare: ssh_get_authentication_socket: No such file or directory
debug1: Will attempt key: C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/id_rsa RSA SHA256:6PeU91XGCYQFWK98s+brNNsvt6blDCNjEvf/PUrygV4
debug1: Will attempt key: C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/id_dsa
debug1: Will attempt key: C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/id_ecdsa
debug1: Will attempt key: C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/id_ed25519
debug1: Will attempt key: C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/id_xmss
debug1: SSH2_MSG_EXT_INFO received
debug1: kex_input_ext_info: server-sig-algs=<ssh-ed25519,ssh-rsa,rsa-sha2-256,rsa-sha2-512,ssh-dss,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521>
debug1: SSH2_MSG_SERVICE_ACCEPT received
debug1: Authentications that can continue: publickey,password
debug1: Next authentication method: publickey
debug1: Offering public key: C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/id_rsa RSA SHA256:6PeU91XGCYQFWK98s+brNNsvt6blDCNjEvf/PUrygV4
debug1: Server accepts key: C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/id_rsa RSA SHA256:6PeU91XGCYQFWK98s+brNNsvt6blDCNjEvf/PUrygV4
debug1: Authentication succeeded (publickey).
Authenticated to 192.168.0.226 ([192.168.0.226]:22).
debug1: channel 0: new [client-session]
debug1: Requesting no-more-sessions@openssh.com
debug1: Entering interactive session.
debug1: pledge: network
debug1: ENABLE_VIRTUAL_TERMINAL_INPUT is supported. Reading the VTSequence from console
debug1: ENABLE_VIRTUAL_TERMINAL_PROCESSING is supported. Console supports the ansi parsing
debug1: client_input_global_request: rtype hostkeys-00@openssh.com want_reply 0
debug1: Remote: /root/.ssh/authorized_keys:1: key options: agent-forwarding port-forwarding pty user-rc x11-forwarding
debug1: Remote: /root/.ssh/authorized_keys:1: key options: agent-forwarding port-forwarding pty user-rc x11-forwarding
Linux debian 4.19.0-18-amd64 #1 SMP Debian 4.19.208-1 (2021-09-29) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Tue Feb 22 14:17:19 2022 from 192.168.0.224
root@debian ~#
```

### 6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.

Скорректировано задание 6

*Папка с ключами в моем windows*
```
 Directory of C:\Users\Sasha.DESKTOP-629HIOD\.ssh

22.02.2022  14:37    <DIR>          .
22.02.2022  14:37    <DIR>          ..
22.02.2022  13:59             2 610 id_rsa
22.02.2022  13:59               576 id_rsa.pub
22.02.2022  14:17               176 known_hosts
               3 File(s)          3 362 bytes
               2 Dir(s)  130 123 853 824 bytes free

C:\Users\Sasha.DESKTOP-629HIOD\.ssh>copy id_rsa prkey
        1 file(s) copied.

C:\Users\Sasha.DESKTOP-629HIOD\.ssh>copy id_rsa.pub prkey.pub
        1 file(s) copied.
```
*Конфигурационный файл с алиасом и измененным ключем*
```	
C:\Users\Sasha.DESKTOP-629HIOD\.ssh>type config
Host debian
  HostName 192.168.0.226
  IdentityFile ~/.ssh/prkey
  User root
  Port 22
  #StrictHostKeyChecking no
```
*захододим по алиасу*
````
C:\Users\Sasha.DESKTOP-629HIOD\.ssh>ssh -v  debian
OpenSSH_for_Windows_8.1p1, LibreSSL 3.0.2
debug1: Reading configuration data C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/config
debug1: C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/config line 1: Applying options for debian
debug1: Connecting to debian [192.168.0.226] port 22.
debug1: Connection established.
debug1: identity file C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/prkey type 0
debug1: identity file C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/prkey-cert type -1
debug1: Local version string SSH-2.0-OpenSSH_for_Windows_8.1
debug1: Remote protocol version 2.0, remote software version OpenSSH_7.9p1 Debian-10+deb10u2
debug1: match: OpenSSH_7.9p1 Debian-10+deb10u2 pat OpenSSH* compat 0x04000000
debug1: Authenticating to 192.168.0.226:22 as 'root'
debug1: SSH2_MSG_KEXINIT sent
debug1: SSH2_MSG_KEXINIT received
debug1: kex: algorithm: curve25519-sha256
debug1: kex: host key algorithm: ecdsa-sha2-nistp256
debug1: kex: server->client cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: kex: client->server cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: expecting SSH2_MSG_KEX_ECDH_REPLY
debug1: Server host key: ecdsa-sha2-nistp256 SHA256:WgDgaAq5/f+OD/HQ4YIwpo4GnNzTHUePfAJSCrWzrNs
debug1: Host '192.168.0.226' is known and matches the ECDSA host key.
debug1: Found key in C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/known_hosts:1
debug1: rekey out after 134217728 blocks
debug1: SSH2_MSG_NEWKEYS sent
debug1: expecting SSH2_MSG_NEWKEYS
debug1: SSH2_MSG_NEWKEYS received
debug1: rekey in after 134217728 blocks
debug1: pubkey_prepare: ssh_get_authentication_socket: No such file or directory
debug1: Will attempt key: C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/prkey RSA SHA256:6PeU91XGCYQFWK98s+brNNsvt6blDCNjEvf/PUrygV4 explicit
debug1: SSH2_MSG_EXT_INFO received
debug1: kex_input_ext_info: server-sig-algs=<ssh-ed25519,ssh-rsa,rsa-sha2-256,rsa-sha2-512,ssh-dss,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521>
debug1: SSH2_MSG_SERVICE_ACCEPT received
debug1: Authentications that can continue: publickey,password
debug1: Next authentication method: publickey
debug1: Offering public key: C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/prkey RSA SHA256:6PeU91XGCYQFWK98s+brNNsvt6blDCNjEvf/PUrygV4 explicit
debug1: Server accepts key: C:\\Users\\Sasha.DESKTOP-629HIOD/.ssh/prkey RSA SHA256:6PeU91XGCYQFWK98s+brNNsvt6blDCNjEvf/PUrygV4 explicit
debug1: Authentication succeeded (publickey).
Authenticated to 192.168.0.226 ([192.168.0.226]:22).
debug1: channel 0: new [client-session]
debug1: Requesting no-more-sessions@openssh.com
debug1: Entering interactive session.
debug1: pledge: network
debug1: ENABLE_VIRTUAL_TERMINAL_INPUT is supported. Reading the VTSequence from console
debug1: ENABLE_VIRTUAL_TERMINAL_PROCESSING is supported. Console supports the ansi parsing
debug1: client_input_global_request: rtype hostkeys-00@openssh.com want_reply 0
debug1: Remote: /root/.ssh/authorized_keys:1: key options: agent-forwarding port-forwarding pty user-rc x11-forwarding
debug1: Remote: /root/.ssh/authorized_keys:1: key options: agent-forwarding port-forwarding pty user-rc x11-forwarding
Linux debian 4.19.0-18-amd64 #1 SMP Debian 4.19.208-1 (2021-09-29) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Tue Feb 22 15:54:09 2022 from 192.168.0.224
root@debian ~#
````
### 7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.

*собираем 100 файлов в формате pcap*
```
root@debian11:/# tcpdump -c 100 -i enp0s8
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on enp0s8, link-type EN10MB (Ethernet), snapshot length 262144 bytes
23:10:36.565015 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 4084083007:4084083055, ack 4130417583, win 501, length 48
23:10:36.565119 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 48:144, ack 1, win 501, length 96
23:10:36.565217 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 48, win 8192, length 0
23:10:36.565265 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 144:192, ack 1, win 501, length 48
23:10:36.565357 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 192:288, ack 1, win 501, length 96
23:10:36.565457 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 192, win 8192, length 0
23:10:36.605735 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 288, win 8191, length 0
23:10:36.684524 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 288:432, ack 1, win 501, length 144
23:10:36.684998 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 432:480, ack 1, win 501, length 48
23:10:36.685364 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 480, win 8190, length 0
23:10:36.685414 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 480:560, ack 1, win 501, length 80
23:10:36.685790 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 560:608, ack 1, win 501, length 48
23:10:36.686019 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 608:688, ack 1, win 501, length 80
23:10:36.686214 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 608, win 8190, length 0
23:10:36.686358 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 688:736, ack 1, win 501, length 48
23:10:36.686583 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 736:800, ack 1, win 501, length 64
23:10:36.686705 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 736, win 8189, length 0
23:10:36.687037 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 800:848, ack 1, win 501, length 48
23:10:36.687255 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 848:912, ack 1, win 501, length 64
23:10:36.687486 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 848, win 8195, length 0
23:10:36.687586 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 912:960, ack 1, win 501, length 48
23:10:36.687990 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 960, win 8194, length 0
23:10:36.688185 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 960:1024, ack 1, win 501, length 64
23:10:36.688569 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 1024:1072, ack 1, win 501, length 48
23:10:36.688701 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 1072:1136, ack 1, win 501, length 64
23:10:36.689003 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 1072, win 8194, length 0
23:10:36.689334 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 1136:1184, ack 1, win 501, length 48
23:10:36.689814 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 1184, win 8194, length 0
23:10:36.767793 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 1184:1264, ack 1, win 501, length 80
23:10:36.767888 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 1264:1376, ack 1, win 501, length 112
23:10:36.767975 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 1376:1424, ack 1, win 501, length 48
23:10:36.768015 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 1376, win 8193, length 0
23:10:36.768126 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 1424:1488, ack 1, win 501, length 64
23:10:36.768203 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 1488:1600, ack 1, win 501, length 112
23:10:36.768287 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 1488, win 8192, length 0
23:10:36.768321 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 1600:1648, ack 1, win 501, length 48
23:10:36.768376 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 1648:1712, ack 1, win 501, length 64
23:10:36.768454 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 1712:1760, ack 1, win 501, length 48
23:10:36.768508 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 1760:1824, ack 1, win 501, length 64
23:10:36.768568 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 1648, win 8192, length 0
23:10:36.768591 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 1824:1872, ack 1, win 501, length 48
23:10:36.768644 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 1872:1936, ack 1, win 501, length 64
23:10:36.768714 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 1760, win 8191, length 0
23:10:36.768719 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 1936:1984, ack 1, win 501, length 48
23:10:36.768778 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 1984:2048, ack 1, win 501, length 64
23:10:36.768843 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 1872, win 8191, length 0
23:10:36.768848 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 2048:2096, ack 1, win 501, length 48
23:10:36.768910 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 2096:2160, ack 1, win 501, length 64
23:10:36.768980 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 1984, win 8190, length 0
23:10:36.768980 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 2096, win 8190, length 0
23:10:36.768986 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 2160:2208, ack 1, win 501, length 48
23:10:36.769046 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 2208:2272, ack 1, win 501, length 64
23:10:36.769146 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 2208, win 8190, length 0
23:10:36.769155 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 2272:2320, ack 1, win 501, length 48
23:10:36.769212 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 2320:2384, ack 1, win 501, length 64
23:10:36.769282 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 2384:2432, ack 1, win 501, length 48
23:10:36.769337 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 2432:2496, ack 1, win 501, length 64
23:10:36.769415 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 2320, win 8195, length 0
23:10:36.769416 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 2432, win 8194, length 0
23:10:36.769427 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 2496:2544, ack 1, win 501, length 48
23:10:36.769487 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 2544:2608, ack 1, win 501, length 64
23:10:36.769548 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 2544, win 8194, length 0
23:10:36.769571 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 2608:2656, ack 1, win 501, length 48
23:10:36.769625 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 2656:2720, ack 1, win 501, length 64
23:10:36.769691 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 2656, win 8194, length 0
23:10:36.769726 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 2720:2768, ack 1, win 501, length 48
23:10:36.769779 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 2768:2832, ack 1, win 501, length 64
23:10:36.769853 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 2832:2880, ack 1, win 501, length 48
23:10:36.769907 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 2880:2944, ack 1, win 501, length 64
23:10:36.769955 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 2768, win 8193, length 0
23:10:36.769956 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 2880, win 8193, length 0
23:10:36.769992 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 2944:2992, ack 1, win 501, length 48
23:10:36.770046 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 2992:3056, ack 1, win 501, length 64
23:10:36.770094 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 2992, win 8192, length 0
23:10:36.770129 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 3056:3104, ack 1, win 501, length 48
23:10:36.770205 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 3104, win 8192, length 0
23:10:36.770231 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 3104:3168, ack 1, win 501, length 64
23:10:36.770301 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 3168:3216, ack 1, win 501, length 48
23:10:36.770384 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 3216, win 8191, length 0
23:10:36.770411 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 3216:3280, ack 1, win 501, length 64
23:10:36.770485 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 3280:3328, ack 1, win 501, length 48
23:10:36.770560 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 3328, win 8191, length 0
23:10:36.770582 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 3328:3392, ack 1, win 501, length 64
23:10:36.770653 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 3392:3440, ack 1, win 501, length 48
23:10:36.770728 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 3440, win 8191, length 0
23:10:36.770751 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 3440:3504, ack 1, win 501, length 64
23:10:36.770844 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 3504:3552, ack 1, win 501, length 48
23:10:36.770962 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 3552, win 8190, length 0
23:10:36.871683 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 3552:3632, ack 1, win 501, length 80
23:10:36.871767 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 3632:3760, ack 1, win 501, length 128
23:10:36.871841 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 3760:3808, ack 1, win 501, length 48
23:10:36.871896 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 3760, win 8189, length 0
23:10:36.871982 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 3808:3872, ack 1, win 501, length 64
23:10:36.872139 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 3872, win 8195, length 0
23:10:36.872183 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 3872:4000, ack 1, win 501, length 128
23:10:36.872400 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 4000:4176, ack 1, win 501, length 176
23:10:36.872549 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 4176, win 8194, length 0
23:10:36.872592 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 4176:4304, ack 1, win 501, length 128
23:10:36.872699 IP 192.168.56.1.55020 > debian11.ssh: Flags [P.], seq 1:97, ack 4176, win 8194, length 96
23:10:36.872766 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 4304:4480, ack 97, win 501, length 176
100 packets captured
122 packets received by filter
0 packets dropped by kernel
```
*записываем в файл 0001.pcap*
```
root@debian11:/# tcpdump -w 0001.pcap -i enp0s8
tcpdump: listening on enp0s8, link-type EN10MB (Ethernet), snapshot length 262144 bytes
^C9 packets captured
10 packets received by filter
0 packets dropped by kernel

root@debian11:/# tcpdump -r 0001.pcap
reading from file 0001.pcap, link-type EN10MB (Ethernet), snapshot length 262144
23:17:43.521293 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 4084092783:4084092847, ack 4130421231, win 501, length 64
23:17:43.521412 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 64:208, ack 1, win 501, length 144
23:17:43.521509 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 64, win 8192, length 0
23:17:43.521570 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 208:288, ack 1, win 501, length 80
23:17:43.521726 IP debian11.ssh > 192.168.56.1.55020: Flags [P.], seq 288:352, ack 1, win 501, length 64
23:17:43.521778 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 288, win 8191, length 0
23:17:43.561480 IP 192.168.56.1.55020 > debian11.ssh: Flags [.], ack 352, win 8191, length 0
23:17:46.875783 LLDP, length 216: debian11.debian11
23:18:16.904151 LLDP, length 216: debian11.debian11
```
