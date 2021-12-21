<!--
This source file is part of the JASS open source project

SPDX-FileCopyrightText: 2019-2021 Paul Schmiedmayer and the JASS project authors (see CONTRIBUTORS.md) <paul.schmiedmayer@tum.de>

SPDX-License-Identifier: MIT
-->

# Jass Deployment Provider Validation

[![Build and Test](https://github.com/JASS-2021/JassDeploymentProviderValidation/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/JASS-2021/JassDeploymentProviderValidation/actions/workflows/build-and-test.yml)

This repository contains the setup and evaluation scripts for the automatic web service deployment using the Apodini IoT Deployment Provider that was used for the JASS 2021.

## Setup
The evaluation has been conducted with a total of **3** Raspberry Pis (A, B, C).
 - 2 LIFX lamps are connected to Raspberry Pi A
 - 1 LIFX lamp is connected to Raspberry Pi B
 - 1 [DuckieBot](https://www.duckietown.org) with Pi C
All Raspberry Pis must be located in a network connected via Ethernet as the WiFi module is used for creating access points.

### Raspberry Pi Setup

1. Use an Imager such as the [https://www.raspberrypi.com/software/](Raspberry Pi Imager) to flash an [Ubuntu Server 21.10 64-bit](https://ubuntu.com/raspberry-pi/server) on an SD card.
2. Start the Raspberry Pi with the SD card, connect to the Raspberry Pi using SSH, and change the default password.
3. Run `ssh-copy-id username@ipaddress` with the username (probably ubuntu) and the IP address of your Raspberry Pi on your machine to enable a more straightforward keyless ssh login.
4. SSH into the Raspberry Pi, clone this repository or copy the script to the Raspberry Pi using `scp` and run the `setup.sh` script to set up the wireless access point, docker installation, and avahi. The Raspberry Pi restarts after the script is complete. 
 - Pass the letter of the Raspberry Pi to the setup script (the default value is `A`), e.g.: `setup.sh B`. 
 - You can also modify the WiFi password as a second argument: `setup.sh B SuperSecretPassword`.
5. Check that the wireless access point is running. It corresponds to the letter of the RapsberryPi instance, e.g. `RaspberryPiA`, and the password is set the same as the access point name if you have not set a separate password.

### LIFX Lamps Setup
When the Raspberry Pis reboot, the access point is automatically started.
To connect the lamps to the access points, connect your mobile phone to the access point and use the [LIFX app](https://www.lifx.com/pages/app) to set up the lamps for each Raspberry Pi subnet. On iOS you can use the settings app to directly connect the LIFX lamps to the WiFi networks without any dedicated app.

### DuckieBot Setup
Since the Raspberry Pi on the DuckieBot is integrated into the DuckieBot, it does not have IoT devices connected to it that would allow us to identify it as a DuckieBot.
The JASS 2021 Deployment Provider uses an empty directory at the root directory named `duckie-util`: `/duckie-util`.
The JassDeploymentProvider runs a post-discovery action and tries to find this folder. If found, the gateway is identified as a DuckieBot.

## Run the JASS 2021 IoT Deployment Provider

The JASS 2021 IoT Deployment Provider is based on the [Apodini IoT Deployment Provider](https://github.com/Apodini/ApodiniIoTDeploymentProvider). The source code and the relevant web service is in this repository. The JASS 2021 IoT Deployment Provider uses the [LIFX Post Discovery Action](https://github.com/JASS-2021/LIFXPostDiscoveryAction) located in this GitHub organization to discover LIFX-based smart lights.

### Configure the JASS 2021 IoT Deployment Provider
To allow a non-interactive setup, you can pass a credentials file that will hold the credentials for the docker images and the Raspberry Pi-based IoT gateways.
The docker images used in the JASS 2021 IoT Deployment providers are public docker images hosted in the GitHub Package Registry. Therefore no docker credentials are needed.
This repository contains a default credentials file in this repository, `credentials.json`, that can be passed to the provider as shown in the next section.

### Start the JASS 2021 IoT Deployment Provider
Build the provider using `swift build`. 

The machine executing the JASS 2021 IoT Deployment Provider must be in the same network as the RaspberryPis.
You can now either:
1. Run the provider once using `swift run LifxDuckieIoTDeploymentTarget --credential-file-path credentials.json`
2. Run the evaluation script (runs the provider 10 times with redownloading docker images and 10 times without redownloading, takes quite a long time) by running: `./jass_simulation.sh IP_A IP_B IP_C`. Replace `IP_A`, `IP_B`, and `IP_C` with the IPs of the respective Raspberry Pis.
Running the evaluation script dumps the logs automatically. If you want to enable this, manually set `--dump-log`. 

To generate plots of the logs, use `evaluation_processing.py` . The script requires two arguments pointing to directories. The first directory should contain the logs of the initial deployment (i.e., redownloading images), the second directory must contain the logs of the recurring deployment.

## Contributing
Contributions to this project are welcome. Please make sure to read the [contribution guidelines](https://github.com/Apodini/.github/blob/main/CONTRIBUTING.md) first.

## License
This project is licensed under the MIT License. See [License](https://github.com/Apodini/Apodini/blob/reuse/LICENSES/MIT.txt) for more information.

## Code of conduct
For our code of conduct see [Code of conduct](https://github.com/Apodini/.github/blob/main/CODE_OF_CONDUCT.md).