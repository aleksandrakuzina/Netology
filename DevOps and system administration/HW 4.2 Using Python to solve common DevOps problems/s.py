#!/usr/bin/env python3
import os

bash_command = ["cd .", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
path = os.popen('cd . && cd').read().replace('\n', '') + '/'
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(path + prepare_result)