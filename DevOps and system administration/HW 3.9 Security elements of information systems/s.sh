#!/bin/bash
echo "" >curl.log
a=("192.168.0.1" "173.194.222.113" "87.250.250.242")
for i in ${a[@]}; do
echo "" >error
echo "" >curl.log
a=("192.168.0.1" "173.194.222.113" "87.250.250.242")
while ((1 == 1)); do
  for i in ${a[@]}; do
    curl http://$i:80 -m 1
    if (($? != 0)); then
      echo "error " $i >>error
      break 2
    else
      echo "OK " $i >>curl.log
    fi
  done
done
