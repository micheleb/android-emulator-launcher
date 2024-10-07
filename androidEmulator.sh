#!/bin/bash
# androidEmulator.sh
#
# A script to launch an Android Emulator without having to open Android Studio.
# Create your androidEmulator.conf file in this folder containing the
# ANDROID_TOOLS and AVD_NAME parameters (see below), and run with no arguments.
# Or name your .conf file however you prefer, and pass its full path to the
# script as the only argument
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PARTITION_SIZE=2048

DEFAULT_CONF=${DIR}/androidEmulator.conf
CONF="${1:-$DEFAULT_CONF}"
source ${CONF}

if [[ ${ANDROID_TOOLS} == "" || ${AVD_NAME} == "" ]]; then
    echo "Create ${DIR}/androidEmulator.conf with at least these 2 lines:"
    echo "  ANDROID_TOOLS=/path/to/your/Android/sdk/tools/folder"
    echo "  AVD_NAME=Device_name"
    echo
    echo "You can get the AVD_NAME from Android Studio's Device Manager,"
    echo "select the AVD and look for AVD NAME in the advanced properties menu."
    echo "Alternatively, run:"
    echo "  emulator -list-avds"
    echo "(emulator is in your Android SDK folder)"
    echo
    echo "Example:"
    echo "  ANDROID_TOOLS=~/Library/Android/sdk/tools"
    echo "  AVD_NAME=Android_TV_1080p_API_28"
    exit 1
fi

echo -ne "Launching Android emulator \033[1;32m"'"'${AVD_NAME}'"'"\033[0m... "
cd ${ANDROID_TOOLS}/../emulator

# remove -no-snapshot if you don't want to do a cold boot every time
./emulator "@${AVD_NAME}" -partition-size ${PARTITION_SIZE} -no-boot-anim -no-snapshot -no-snapshot-save &

echo "Launched!"

echo "Waiting for device to be ready..."
cd ${ANDROID_TOOLS}/../platform-tools
./adb wait-for-device shell 'while [[ -z $(getprop sys.boot_completed) ]]; do sleep 1; done;'

# wait-for-device returns a bit too early on recent emulators, wait some more
sleep 5

# React Native stuff
echo "Running adb reverse tcp:9090 tcp:9090 (needed for Reactotron)..."
./adb reverse tcp:9090 tcp:9090

echo "Running adb reverse tcp:8081 tcp:8081 (needed to debug)..."
./adb reverse tcp:8081 tcp:8081

echo "Running adb reverse tcp:8097 tcp:8097 (needed for ReactDevTools)..."
./adb reverse tcp:8097 tcp:8097
# Endof React Native stuff

echo "Ready!"
