#!/usr/bin/env bash

source common.sh || source scripts/common.sh || echo "No common.sh script found..."

set -e

echo -e "Ensure that all the apps are built and H2 is running!\n"
stop_h2
clear_h2
run_h2
build_all_apps

# APP 1.0.0 and 2.0.0.BAD

cat <<EOF
This Bash file will show you the scenario in which the app will be ran in version 1.0.0 and 2.0.0 simultaneously.
We will do it in the following way:

01) Run 1.0.0
02) Wait for the app (1.0.0) to boot
03) Generate a person by calling POST localhost:9991/person to version 1.0.0
04) Run 2.0.0.BAD
05) Wait for the app (2.0.0.BAD) to boot
06) Generate a person by calling POST localhost:9991/person to version 1.0.0 <-- this should fail
07) Generate a person by calling POST localhost:9992/person to version 2.0.0.BAD <-- this should pass

EOF

echo -e "\nStarting app in version 1.0.0\n"
java_jar boot-flyway-v1 -Dspring.profiles.active=standalone

echo -e "\nWaiting for the app 1.0.0. to boot\n"
curl_local_health_endpoint 9991

echo -e "\nGenerate a person in version 1.0.0\n"
generate_person 9991

echo -e "\nStarting app in version 2.0.0.BAD\n"
java_jar boot-flyway-v2-bad -Dspring.profiles.active=standalone

echo -e "\nWaiting for the app 2.0.0.BAD to boot\n"
curl_local_health_endpoint 9995

echo -e "\nGenerate a person in version 1.0.0\n"
(generate_person 9991) || echo -e "\n\n EXCEPTION OCCURRED WHILE TRYING TO GENERATE A PERSON. THAT'S BECAUSE THE APP IS BACKWARDS INCOMPATIBLE"

echo -e "\nGenerate a person in version 2.0.0.BAD\n"
generate_person 9995 && echo -e "\n\n AND THIS PASSED CAUSE THIS VERSION OF THE APP INTRODUCED BACKWARDS INCOMPATBILE CHANGES"