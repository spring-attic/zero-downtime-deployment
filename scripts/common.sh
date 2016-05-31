#!/usr/bin/env bash

set -e

WAIT_TIME="${WAIT_TIME:-5}"
RETRIES="${RETRIES:-70}"
SERVICE_PORT="${SERVICE_PORT:-8081}"

# ${RETRIES} number of times will try to curl to /health endpoint to passed port $1 and localhost
function curl_local_health_endpoint() {
    curl_health_endpoint $1 "127.0.0.1"
}

# ${RETRIES} number of times will try to curl to /health endpoint to passed port $1 and host $2
function curl_health_endpoint() {
    local PASSED_HOST="${2:-$HEALTH_HOST}"
    local READY_FOR_TESTS=1
    for i in $( seq 1 "${RETRIES}" ); do
        sleep "${WAIT_TIME}"
        curl -m 5 "${PASSED_HOST}:$1/health" && READY_FOR_TESTS=0 && break
        echo "Fail #$i/${RETRIES}... will try again in [${WAIT_TIME}] seconds"
    done
    return $READY_FOR_TESTS
}

# Runs the `java -jar` for given application $1 and system properties $2
function java_jar() {
    echo -e "Starting app $1 \n"
    local APP_JAVA_PATH=$1/target
    local EXPRESSION="nohup ${JAVA_PATH_TO_BIN}java $2 $MEM_ARGS -jar $APP_JAVA_PATH/*.jar >$APP_JAVA_PATH/nohup.log &"
    echo -e "\nTrying to run [$EXPRESSION]"
    eval $EXPRESSION
    pid=$!
    echo $pid > $APP_JAVA_PATH/app.pid
    echo -e "[$1] process pid is [$pid]"
    echo -e "System props are [$2]"
    echo -e "Logs are under [$APP_JAVA_PATH/nohup.log]\n"
    return 0
}

# Kills an app with given $1 version
function kill_app() {
    echo -e "\nKilling app $1\n"
    pkill -f "spring-boot-sample-flyway-$1-SNAPSHOT"
    return 0
}

# Runs H2 from proper folder
function build_all_apps() {
    ${ROOT_FOLDER}/scripts/build_all.sh
}

# Kill all the apps
function kill_all_apps() {
    ${ROOT_FOLDER}/scripts/kill_apps.sh
}

# Runs H2 from proper folder
function run_h2() {
    ${ROOT_FOLDER}/scripts/startH2.sh
}

# Stops H2 from proper folder
function stop_h2() {
    ${ROOT_FOLDER}/scripts/stopH2.sh
}

# Stops H2 from proper folder
function clear_h2() {
    ${ROOT_FOLDER}/scripts/clearH2.sh
}

# Calls a POST curl to /person to an app on localhost with port $1
function generate_person() {
    echo -e "Sending a post to 127.0.0.1:$1/person. This is the response:\n"
    curl --fail -X POST "127.0.0.1:${1}/person"
    return $?
}

export WAIT_TIME
export RETIRES
export SERVICE_PORT

export -f curl_local_health_endpoint
export -f curl_health_endpoint
export -f java_jar
export -f build_all_apps
export -f run_h2
export -f stop_h2
export -f clear_h2
export -f generate_person
export -f kill_app
export -f kill_all_apps

ROOT_FOLDER=`pwd`
if [[ ! -e "${ROOT_FOLDER}/h2" ]]; then
    cd ..
    ROOT_FOLDER=`pwd`
    if [[ ! -e "${ROOT_FOLDER}/h2" ]]; then
        echo "No h2 folder found"
        exit 1
    fi
fi

mkdir -p ${ROOT_FOLDER}/target