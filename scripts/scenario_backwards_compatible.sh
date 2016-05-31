#!/usr/bin/env bash

source common.sh || source scripts/common.sh || echo "No common.sh script found..."

set -e

echo -e "Ensure that all the apps are built and H2 is running!\n"
stop_h2
clear_h2
run_h2
build_all_apps

# APP 1.0.0 and 2.0.0

cat <<EOF
This Bash file will show you the scenario in which the app will be ran in version 1.0.0 and 2.0.0 simultaneously.
We will do it in the following way:

01) Run 1.0.0
02) Wait for the app (1.0.0) to boot
03) Generate a person by calling POST localhost:9991/person to version 1.0.0
04) Run 2.0.0
05) Wait for the app (2.0.0) to boot
06) Generate a person by calling POST localhost:9991/person to version 1.0.0
07) Generate a person by calling POST localhost:9992/person to version 2.0.0
08) Kill app (1.0.0)
09) Run 3.0.0
10) Wait for the app (3.0.0) to boot
11) Generate a person by calling POST localhost:9992/person to version 2.0.0
12) Generate a person by calling POST localhost:9993/person to version 3.0.0
13) Kill app (3.0.0)
14) Run 4.0.0
15) Wait for the app (4.0.0) to boot
16) Generate a person by calling POST localhost:9993/person to version 3.0.0
17) Generate a person by calling POST localhost:9994/person to version 4.0.0

EOF

echo -e "\nStarting app in version 1.0.0\n"
java_jar boot-flyway-v1 -Dspring.profiles.active=standalone

echo -e "\nWaiting for the app 1.0.0. to boot\n"
curl_local_health_endpoint 9991

echo -e "\nGenerate a person in version 1.0.0\n"
generate_person 9991

echo -e "\nStarting app in version 2.0.0\n"
java_jar boot-flyway-v2 -Dspring.profiles.active=standalone

echo -e "\nWaiting for the app 2.0.0 to boot\n"
curl_local_health_endpoint 9992

echo -e "\nGenerate a person in version 1.0.0\n"
generate_person 9991

echo -e "\nGenerate a person in version 2.0.0\n"
generate_person 9992

# APP 2.0.0 and 3.0.0

kill_app "1.0.0"

echo -e "\nStarting app in version 3.0.0\n"
java_jar boot-flyway-v3 -Dspring.profiles.active=standalone

echo -e "\nWaiting for the app 3.0.0. to boot\n"
curl_local_health_endpoint 9993

echo -e "\nGenerate a person in version 2.0.0\n"
generate_person 9992

echo -e "\nGenerate a person in version 3.0.0\n"
generate_person 9993

# APP 3.0.0 and 4.0.0

kill_app "2.0.0"

echo -e "\nStarting app in version 4.0.0\n"
java_jar boot-flyway-v4 -Dspring.profiles.active=standalone

echo -e "\nWaiting for the app 4.0.0. to boot\n"
curl_local_health_endpoint 9994

echo -e "\nGenerate a person in version 3.0.0\n"
generate_person 9993

echo -e "\nGenerate a person in version 4.0.0\n"
generate_person 9994