### Процесс установки и настройки ufw
````
root@kursach:/home/defuser# apt install ufw
````
````
root@kursach:/home/defuser# ufw status verbose
Status: inactive
````
````
root@kursach:/home/defuser# ufw allow 22/tcp
Skipping adding existing rule
Skipping adding existing rule (v6)
````
````
root@kursach:/home/defuser# ufw allow ssh
Rules updated
Rules updated (v6)
````
````
root@kursach:/home/defuser# ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
````
````
root@kursach:/home/defuser# ufw status
Status: active

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
22/tcp (v6)                ALLOW       Anywhere (v6)
````
````
root@kursach:/home/defuser# ufw default deny incoming
Default incoming policy changed to 'deny'
(be sure to update your rules accordingly)
````
````
root@kursach:/home/defuser# ufw default allow outgoing
Default outgoing policy changed to 'allow'
(be sure to update your rules accordingly)
````
````
root@kursach:/home/defuser# ufw show listening
tcp:
  22 * (sshd)
   [ 1] allow 22/tcp

tcp6:
  22 * (sshd)
   [ 2] allow 22/tcp

  80 * (apache2)
  
udp:
  47278 * (avahi-daemon)
  5353 * (avahi-daemon)
  631 * (cups-browsed)
  68 192.168.1.74 (NetworkManager)
  
udp6:
  44074 * (avahi-daemon)
  5353 * (avahi-daemon)
  546 fe80::a00:27ff:fe75:adad (NetworkManager)
````
````
root@kursach:/home/defuser# ufw allow from 127.0.0.1 to any
Rule added
````
````
root@kursach:/home/defuser# ufw allow 443
Rule added
Rule added (v6)
````
````
root@kursach:/home/defuser# ufw status
Status: active
To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
Anywhere                   ALLOW       127.0.0.1
443                        ALLOW       Anywhere
22/tcp (v6)                ALLOW       Anywhere (v6)
443 (v6)                   ALLOW       Anywhere (v6)
````

### Процесс установки и выпуска сертификата с помощью hashicorp vault
````
root@kursach:/home/defuser# curl -S https://apt.releases.hashicorp.com/gpg | apt-key add -
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0Warning: apt-key is deprecated. Manage keyring files in trusted.gpg.d instead (see apt-key(8)).
100  3195  100  3195    0     0   4945      0 --:--:-- --:--:-- --:--:--  4945
OK
````

````
root@kursach:/home/defuser# apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
````
````
root@kursach:/home/defuser# apt-get update && apt-get install vault
````
````
root@kursach:/home/defuser# vault server -dev -dev-root-token-id root (в отдельном терминале)
root@kursach:/home/defuser# export VAULT_ADDR=http://127.0.0.1:8200
root@kursach:/home/defuser# export VAULT_TOKEN=root
````

````
root@kursach:/home/defuser# vault secrets enable pki
Success! Enabled the pki secrets engine at: pki/
````

````
root@kursach:/home/defuser# vault secrets tune -max-lease-ttl=720h pki
Success! Tuned the secrets engine at: pki/
````
````
 root@kursach:/home/defuser# vault write -field=certificate pki/root/generate/internal common_name="example.com" ttl=720h > CA_cert.crt
````
````
root@kursach:/home/defuser# vault write pki/config/urls issuing_certificates="$VAULT_ADDR/v1/pki/ca" crl_distribution_points="$VAULT_ADDR/v1/pki/crl"
Success! Data written to: pki/config/urls
````

----Generate intermediate CA-----
````
root@kursach:/home/defuser# vault secrets enable -path=pki_int pki
Success! Enabled the pki secrets engine at: pki_int/
````
````
root@kursach:/home/defuser# vault secrets tune -max-lease-ttl=720h pki_int
Success! Tuned the secrets engine at: pki_int/
````
````
root@kursach:/home/defuser# vault write -format=json pki_int/intermediate/generate/internal common_name="example.com Intermediate Authority" | jq -r '.data.csr' > pki_intermediate.csr
````
````
root@kursach:/home/defuser# vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr format=pem_bundle ttl="720h" | jq -r '.data.certificate' > intermediate.cert.pem
````
````
root@kursach:/home/defuser# vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem
Success! Data written to: pki_int/intermediate/set-signed
````

----Create a role-----
````
root@kursach:/home/defuser# vault write pki_int/roles/example-dot-com allowed_domains="example.com" allow_subdomains=true max_ttl="720h"
Success! Data written to: pki_int/roles/example-dot-com
````

----Request certificates-----
````
root@kursach:/home/defuser# vault write pki_int/issue/example-dot-com common_name="www.example.com" ttl="24h" > www.example.com.crt
````
````
root@kursach:/home/defuser# cat www.example.com.crt
Key                 Value
---                 -----
ca_chain            [-----BEGIN CERTIFICATE-----
MIIDpjCCAo6gAwIBAgIUayRpZQYDs9J2jaZzM7uYfUL8vU8wDQYJKoZIhvcNAQEL
BQAwFjEUMBIGA1UEAxMLZXhhbXBsZS5jb20wHhcNMjIwNjA1MTY1NTQ5WhcNMjIw
NzA1MTY1NjE5WjAtMSswKQYDVQQDEyJleGFtcGxlLmNvbSBJbnRlcm1lZGlhdGUg
QXV0aG9yaXR5MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqSie+a+O
nIklsz/o6T1GYh/pGINbh3DGH/Tq3CMn1No5hyEu+2ILUt0QAi2vPt0GI9W+muWT
XVHaPpGfXKe6Ut//7HZFbu2Rabm3TZUQ2Myyf23YCb8fFN5pu/jzPQT+6X0doGV8
LHEMASAYfPIdHKhOuSUIzu7J6wcxtIUW+7MqGelbybgVJv7ZZQmTgzflP0xn7iLS
ecbP5F/CG1At8k0Z/Xw5Tc/0REJt4FswIDJ62pBmgOvFdNZU8R8cmuqYWc8JxuTj
vkn5+DxCwhMnJyuNZfw2f7BjeVHGSdFL/EXuSs8bnuP7Z1uzjNX7OSMjCcGf2Fy9
NG6G0fOBywagowIDAQABo4HUMIHRMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8E
BTADAQH/MB0GA1UdDgQWBBS/zKFP4GNgzhd1QPDPQtAd2l0d/DAfBgNVHSMEGDAW
gBRRsZHuSrIaFPmMFbuoWmJYI+60gDA7BggrBgEFBQcBAQQvMC0wKwYIKwYBBQUH
MAKGH2h0dHA6Ly8xMjcuMC4wLjE6ODIwMC92MS9wa2kvY2EwMQYDVR0fBCowKDAm
oCSgIoYgaHR0cDovLzEyNy4wLjAuMTo4MjAwL3YxL3BraS9jcmwwDQYJKoZIhvcN
AQELBQADggEBAAKhkYrpktsfqv1eBI4oMCSHwQrp8o+5SGeeGMIUU1MMGbVmW5oj
uv3HYNPeyBS/pPMVxQ56Bb7PtJMCtfVhen+RrYRsbsFd/tAeLrFEJChuX8FCOAMH
Vfr8yblEZaqO4NVu2PJFqj+2D7/xQc4Yd1rDPC9/Ui1UwNHdIqQ0Svezvt0sD4ut
wn4IqxcAOEUl2MpAAyKblqcastg4bdg6p7bNWzRdRlXw/qqYavze45xXm8aNzHi7
P1f3zk1AjWSKgI7zul9CY2o2wuzCpt/AC7bTVea+rwg7GF305gxH4RrLumy8ZweO
V0o0vNNCb74KkFi86rPWfCyf0TX4adLtwdA=
-----END CERTIFICATE-----]
certificate         -----BEGIN CERTIFICATE-----
MIIDZDCCAkygAwIBAgIUWkj/DOba2jSv+auir0Fsi3QaFXswDQYJKoZIhvcNAQEL
BQAwLTErMCkGA1UEAxMiZXhhbXBsZS5jb20gSW50ZXJtZWRpYXRlIEF1dGhvcml0
eTAeFw0yMjA2MDUxODQ4MDlaFw0yMjA2MDYxODQ4MzlaMBoxGDAWBgNVBAMTD3d3
dy5leGFtcGxlLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKU4
CytD6n8/Yrfqyw+e3qoTbzAyRb8nVOht5Zkm8ABBEljaPbnw7+qAI6vIqDKdi28K
PD0K+do2FSIEq8uGUQ++FhTfeU/mh7TvVJhoIbi030GGy3fP/KO9euQ8IMAT+0KS
wrdvoLez4VHpd6Pz90/gzDxS5HPytYxD4OhY+sK/5a+LTt8gFoyo1VamvLXNn0AQ
oZTs6ccxSA78DTamk1t+tQ0QCDrx3aRjCKTnuV0yeDjruTTAX0PNsi0bkUMpa0OY
AGsz0Y3A+dhv5xVS2AFxqs0bmm7v/caXSS9rTu3T/gO1MjoqI44VnVcpv83M9C0R
8yY/+qfDe3L6PBufwqcCAwEAAaOBjjCBizAOBgNVHQ8BAf8EBAMCA6gwHQYDVR0l
BBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMB0GA1UdDgQWBBRrpK3ZkIrKAx8J2m3T
Qq1JGB/BLDAfBgNVHSMEGDAWgBS/zKFP4GNgzhd1QPDPQtAd2l0d/DAaBgNVHREE
EzARgg93d3cuZXhhbXBsZS5jb20wDQYJKoZIhvcNAQELBQADggEBADBmKYjS/nxA
EzHbTVANWQKtEfOMcjs4F/qI14KnCmK6soqHACmlLN2jtWcxQEuJ/ZsZ6cFSPtPT
afuve7RKc6L61VKPSWvwugyt3aEQJu74S4qBlw3T3OVkxBOObs+anbKTekE7o8HT
2RTg3JVpIbxtHquSSR2FBlyB1T5+QSEJKu5wWR2QqBMXtuByAnJm1Oxo6f9ufBkV
l1qLdE6cx3zfO9dX9LzGO1B6rLY0Moqf+feV45zDCqAZvG1nnUNRNKWjtoOpFsTg
yQ2E02qKOv+TtgFHT3R2ynANbK33xPo4vUPG02PI2jIhyFRIC7Fpydm2VPvgGMSd
OHPmMMEjSoc=
-----END CERTIFICATE-----
expiration          1654541319
issuing_ca          -----BEGIN CERTIFICATE-----
MIIDpjCCAo6gAwIBAgIUayRpZQYDs9J2jaZzM7uYfUL8vU8wDQYJKoZIhvcNAQEL
BQAwFjEUMBIGA1UEAxMLZXhhbXBsZS5jb20wHhcNMjIwNjA1MTY1NTQ5WhcNMjIw
NzA1MTY1NjE5WjAtMSswKQYDVQQDEyJleGFtcGxlLmNvbSBJbnRlcm1lZGlhdGUg
QXV0aG9yaXR5MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqSie+a+O
nIklsz/o6T1GYh/pGINbh3DGH/Tq3CMn1No5hyEu+2ILUt0QAi2vPt0GI9W+muWT
XVHaPpGfXKe6Ut//7HZFbu2Rabm3TZUQ2Myyf23YCb8fFN5pu/jzPQT+6X0doGV8
LHEMASAYfPIdHKhOuSUIzu7J6wcxtIUW+7MqGelbybgVJv7ZZQmTgzflP0xn7iLS
ecbP5F/CG1At8k0Z/Xw5Tc/0REJt4FswIDJ62pBmgOvFdNZU8R8cmuqYWc8JxuTj
vkn5+DxCwhMnJyuNZfw2f7BjeVHGSdFL/EXuSs8bnuP7Z1uzjNX7OSMjCcGf2Fy9
NG6G0fOBywagowIDAQABo4HUMIHRMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8E
BTADAQH/MB0GA1UdDgQWBBS/zKFP4GNgzhd1QPDPQtAd2l0d/DAfBgNVHSMEGDAW
gBRRsZHuSrIaFPmMFbuoWmJYI+60gDA7BggrBgEFBQcBAQQvMC0wKwYIKwYBBQUH
MAKGH2h0dHA6Ly8xMjcuMC4wLjE6ODIwMC92MS9wa2kvY2EwMQYDVR0fBCowKDAm
oCSgIoYgaHR0cDovLzEyNy4wLjAuMTo4MjAwL3YxL3BraS9jcmwwDQYJKoZIhvcN
AQELBQADggEBAAKhkYrpktsfqv1eBI4oMCSHwQrp8o+5SGeeGMIUU1MMGbVmW5oj
uv3HYNPeyBS/pPMVxQ56Bb7PtJMCtfVhen+RrYRsbsFd/tAeLrFEJChuX8FCOAMH
Vfr8yblEZaqO4NVu2PJFqj+2D7/xQc4Yd1rDPC9/Ui1UwNHdIqQ0Svezvt0sD4ut
wn4IqxcAOEUl2MpAAyKblqcastg4bdg6p7bNWzRdRlXw/qqYavze45xXm8aNzHi7
P1f3zk1AjWSKgI7zul9CY2o2wuzCpt/AC7bTVea+rwg7GF305gxH4RrLumy8ZweO
V0o0vNNCb74KkFi86rPWfCyf0TX4adLtwdA=
-----END CERTIFICATE-----
private_key         -----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEApTgLK0Pqfz9it+rLD57eqhNvMDJFvydU6G3lmSbwAEESWNo9
ufDv6oAjq8ioMp2Lbwo8PQr52jYVIgSry4ZRD74WFN95T+aHtO9UmGghuLTfQYbL
d8/8o7165DwgwBP7QpLCt2+gt7PhUel3o/P3T+DMPFLkc/K1jEPg6Fj6wr/lr4tO
3yAWjKjVVqa8tc2fQBChlOzpxzFIDvwNNqaTW361DRAIOvHdpGMIpOe5XTJ4OOu5
NMBfQ82yLRuRQylrQ5gAazPRjcD52G/nFVLYAXGqzRuabu/9xpdJL2tO7dP+A7Uy
OiojjhWdVym/zcz0LRHzJj/6p8N7cvo8G5/CpwIDAQABAoIBAQCQ2gvgyNCk83un
Z7DUZyMs1ZEcHldL+j3U8dTka2DruCFPyTdo+DY/0Ex15Zyhk8KVfdHGawMXL2dj
xdigvYgAV1WgwzTmumSsW1A9tr4p5FoAZx+oUa9cF1nRFG5aOKqHeYhBrxqnNIwN
drUwB0sCu0IUeVBV36sP6MscqjZf2tnHRXttPqYnhMkWX6ccyXpRT6o+So8nS/Fo
S2Zj2JOWlAQMI/pf57cEzVCEppYISZrg2x9z7wegXbHTlBqo2bcTTvqdcEdRSTO+
w6ffEf9sUU9UWJ5raYMlbTUYuCEm2IvjNVajfhJmDtuBx2KDnygKtq03WLkXtNQl
7GbPRGjxAoGBAMdYOWHiv1nJrU7gT/nmBKdYW8uKY1+jSb9ct2ieONKPtLpHGNDx
zy3Bw3nTPFW+QgZqev5ohRU33Q6mnmRNywZfuLGqH8IXLjJBioprTJfSsqxqnzLb
6fv3qlVBQRVwqihg9HTQ1zcFXu5RcguDqSaQrIl3Oph/FHZiSyyO+ir9AoGBANQs
7OsFsHu4dqljPVl5doLkpCFWjV1mRIG31XWKYYMZ3h/OXlbJPNGHxEYNmVd0IhKl
M242klUbkpoFTLeiRfhDIQ1h3uvtuh3R6AO7BuPdXm2lrtYs/Ez3miINofOPoxA+
WUtgH+/AEjfK0BeLDEn2ZskQvN1rv0PSK/YA4i9zAoGAS6y7Q+SfPYepKgtPcQ+X
7qtFVbR4WwMS6PlaivWdnpl9Q0XgLtnNC5LGEUZWXjp2uBbOECw/cTmeyoQIFw3N
J+NIqvFpUvYXzG5DGJ75GZ2bxIZJXzZK0iNH30uBWJFHl0KPKpVpTfLVAeWbRLG7
ke9UAG9pqCB99R8FaKnyYEUCgYBRl10cG7n8OblX9hO3fp/2Qdpj/5apHhSmFX1+
j9JjyeTDMmbQ1N4QbTcrATvAh6Y6qVCXx2CKXeoIVJVl4H8rsxTYwpQpAegaY4fn
N1q08YHIhHgxYGc9adHZ2og20zuPmYpZFAPz/FaFIfbXtt7o6looY8ldFHweponF
Nh3ExQKBgQCCJztyTcy15bZhxP+bVJgidmRoBYbAoMUBgdO04Fw5GC+iWpf6nmLj
LNoBJ0WP7vsIuIfzdnL2ijHAVkMDIFi6jcdpSbj4mUh5GSBUec+s8IBQnYLLkpeR
6qdQsDDSTLos47DbIuSDxcMaD07Zn5/3F1tobA/FCL8CJ9kSA64ywg==
-----END RSA PRIVATE KEY-----
private_key_type    rsa
serial_number       5a:48:ff:0c:e6:da:da:34:af:f9:ab:a2:af:41:6c:8b:74:1a:15:7b
````

````
root@kursach:/home/defuser# apt-get install nginx-full
````
````
root@kursach:/home/defuser# systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2022-06-05 20:39:47 MSK; 1min 6s ago
       Docs: man:nginx(8)
    Process: 35988 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
    Process: 35989 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
   Main PID: 36141 (nginx)
      Tasks: 3 (limit: 4663)
     Memory: 3.4M
        CPU: 25ms
     CGroup: /system.slice/nginx.service
             ├─36141 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
             ├─36144 nginx: worker process
             └─36145 nginx: worker process

июн 05 20:39:47 kursach systemd[1]: Starting A high performance web server and a reverse proxy server...
июн 05 20:39:47 kursach systemd[1]: Started A high performance web server and a reverse proxy server.
````

![Alt text](2022-06-04_235340.png)