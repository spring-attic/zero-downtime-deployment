#!/usr/bin/env bash

source common.sh || source scripts/common.sh || echo "No common.sh script found..."

mkdir -p target
H2_FOLDER="${ROOT_FOLDER}/h2"

if [[ ! -e "${ROOT_FOLDER}/target/h2.pid" ]]; then
    echo "Running H2 from [${H2_FOLDER}]"
    nohup ${H2_FOLDER}/h2.sh > target/h2.log &
    pid=$!
    echo $pid > $ROOT_FOLDER/target/h2.pid
    echo "H2 process pid is [$pid]"
    echo "H2 process pid file is here [target/h2.pid]"
    echo "H2 logs are present under [target/h2.log]"
else
    echo "H2 is already running. Check the PID"
    cat $ROOT_FOLDER/target/h2.pid
fi
