
#!/usr/bin/env python3

import os
import sys

repo_path = sys.argv[1]
bash_command = ["cd " + repo_path, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
path = os.popen('cd ' + repo_path + '&& cd').read().replace('\n', '') + '/'
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(path + prepare_result)