#!/usr/bin/env bash

source common.sh || source scripts/common.sh || echo "No common.sh script found..."

mkdir -p target
H2_FOLDER="${ROOT_FOLDER}/h2"

if [[ ! -e "${ROOT_FOLDER}/target/h2.pid" ]]; then
    echo "Can't stop h2 since it's not running"
else
    echo "H2 PID:"
    cat "${ROOT_FOLDER}/target/h2.pid"
    pid=`ps | grep h2-1.3.176 | awk 'NR==1{print $1}' | cut -d' ' -f1`
    kill -9 $pid && echo "Killed the jar process with H2" || echo "There was no h2 process running"
    rm ${ROOT_FOLDER}/target/h2.pid
fi
