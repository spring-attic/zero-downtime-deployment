#!/usr/bin/env bash

./scripts/kill_apps.sh || ./kill_apps.sh
./scripts/stopH2.sh || ./stopH2.sh
./scripts/clearH2.sh || ./clearH2.sh