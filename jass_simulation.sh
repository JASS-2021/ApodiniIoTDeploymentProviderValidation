#
# This source file is part of the JASS open source project
#
# SPDX-FileCopyrightText: 2019-2021 Paul Schmiedmayer and the JASS project authors (see CONTRIBUTORS.md) <paul.schmiedmayer@tum.de>
#
# SPDX-License-Identifier: MIT
#

GREEN='\033[0;32m'
DEFAULT='\033[0m'

# You can pass the addresses to the script as arguments
IP1="${1:-192.168.178.50}"
IP2="${2:-192.168.178.51}"
IP3="${3:-192.168.178.52}"
ipAddresses=( "$IP1" "$IP2" "$IP3" )

function reset() {
    for ipAddress in "${ipAddresses[@]}"; do
        ssh ubuntu@$ipAddress "docker stop ApodiniIoTDockerInstance; docker rm ApodiniIoTDockerInstance; docker image prune -a -f"
    done
}

function stop() {
    echo "Stopping running instances"
    for ipAddress in "${ipAddresses[@]}"; do
        ssh ubuntu@$ipAddress "docker stop ApodiniIoTDockerInstance"
    done
}

function testDuckieDeployment() {
    echo "Testing if duckie deployment was successful"
    
    # C should have duckie & common endpoints
    shouldFailcall=$(curl -s -o /dev/null -w "%{http_code}" ${ipAddresses[2]}:8080/v1/lifx)
    shouldSucceedCall1=$(curl -s -o /dev/null -w "%{http_code}" ${ipAddresses[2]}:8080/v1/duckie)
    shouldSucceedCall2=$(curl -s -o /dev/null -w "%{http_code}" ${ipAddresses[2]}:8080/v1/common)
    
    if [ $shouldSucceedCall1 -eq 200 ] && [ $shouldSucceedCall2 -eq 200 ] && [ $shouldFailcall -ne 200 ]; then
        echo "${GREEN}\xE2\x9C\x94 SUCCESS${DEFAULT}: Duckie Deployment Test was successful"
    else
        echo "${RED} Duckie Deployment Test failed!${DEFAULT}"
        exit 1
    fi
}

function testLifxDeployment() {
    echo "Testing if lifx deployment was successful"
    errorOccurred=false
    
    # A should have lifx & common endpoints
    shouldFailcall=$(curl -s -o /dev/null -w "%{http_code}" ${ipAddresses[0]}:8080/v1/duckie)
    shouldSucceedCall1=$(curl -s -o /dev/null -w "%{http_code}" ${ipAddresses[0]}:8080/v1/lifx)
    shouldSucceedCall2=$(curl -s -o /dev/null -w "%{http_code}" ${ipAddresses[0]}:8080/v1/common)
    if [ $shouldSucceedCall1 -eq 200 ] && [ $shouldSucceedCall2 -eq 200 ] && [ $shouldFailcall -ne 200 ]; then
        echo "${GREEN}\xE2\x9C\x94 SUCCESS${DEFAULT}: LIFX Deployment for Rapsberry Pi A was successful"
    else
        errorOccurred=true
    fi
    
    # B should have lifx & common endpoints
    shouldFailcall=$(curl -s -o /dev/null -w "%{http_code}" ${ipAddresses[1]}:8080/v1/duckie)
    shouldSucceedCall1=$(curl -s -o /dev/null -w "%{http_code}" ${ipAddresses[1]}:8080/v1/lifx)
    shouldSucceedCall2=$(curl -s -o /dev/null -w "%{http_code}" ${ipAddresses[1]}:8080/v1/common)
    if [ $shouldSucceedCall1 -eq 200 ] && [ $shouldSucceedCall2 -eq 200 ] && [ $shouldFailcall -ne 200 ]; then
        echo "${GREEN}\xE2\x9C\x94 SUCCESS${DEFAULT}: LIFX Deployment for Rapsberry Pi B was successful"
    else
        errorOccurred=true
    fi
    
    if [ "$errorOccurred" = false ]; then
        echo "${GREEN}\xE2\x9C\x94 SUCCESS${DEFAULT}: Both LIFX Deployment Test were successful"
    else
        echo "${RED} LIFX Deployment Test failed!${DEFAULT}"
        exit 1
    fi
}

echo "Testing initial deployment. Downloading images only on first run"
for ((i=1;i<=10;i++)); do
    reset
    swift run LifxDuckieIoTDeploymentTarget --credential-file-path credentials.json
    testLifxDeployment
    testDuckieDeployment
done

sleep 15

echo "Testing without docker reset. Assuming needed images are already downloaded"

for ((i=1;i<=10;i++)); do
    stop
    swift run LifxDuckieIoTDeploymentTarget --credential-file-path credentials.json
    testLifxDeployment
    testDuckieDeployment
done


