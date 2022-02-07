#!/usr/bin/env python3
import os.path
import socket

hosts = ["drive.google.com", "mail.google.com", "google.com"]
last_check_filepath = 'myfile.txt'
delimiter = ";"


def remove_file(filename):
    try:
        os.remove(filename)
    except OSError:
        pass


def load_last_check():
    ip_by_host = {}
    if os.path.isfile(last_check_filepath):
        file = open(last_check_filepath, 'r')
        lines = file.readlines()
        for line in lines:
            args = line.split(delimiter)
            ip_by_host[args[0]] = args[1].replace("\n", "")
    return ip_by_host


def write_to_file(ip_by_host):
    remove_file(last_check_filepath)
    fp = open(last_check_filepath, 'w')
    for (host, port) in ip_by_host.items():
        fp.write(host + delimiter + port + "\n")
    fp.close()


ip_by_host_last = load_last_check()
ip_by_host = {}

for host in hosts:
    ip = socket.gethostbyname(host)
    ip_by_host[host] = ip
    print(host + ' ' + ip)
    oldIp = ip_by_host_last.get(host)
    if oldIp and oldIp != ip:
        print("Error oldip[" + oldIp + "] != new ip[" + ip + "] for host " + host)

write_to_file(ip_by_host)
