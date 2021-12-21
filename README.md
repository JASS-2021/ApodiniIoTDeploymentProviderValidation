<!--
This source file is part of the JASS open source project

SPDX-FileCopyrightText: 2019-2021 Paul Schmiedmayer and the JASS project authors (see CONTRIBUTORS.md) <paul.schmiedmayer@tum.de>

SPDX-License-Identifier: MIT
-->

# Jass Deployment Provider Evaluation

This repository contains the setup and evaluation scripts for the automatic web service deployment using the Apodini IoT Deployment Provider that was used for the JASS 2021.

## Setup
The evaluation has been conducted with a total of **3** Raspberry Pis (A, B, C).
 - 2 LIFX lamps are connected to Raspberry Pi A
 - 1 LIFX lamp is connected to Raspberry Pi A
 - 1 [DuckieBot]() with Pi C

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
To connect the lamps to the access points, connect your mobile phone to the access point and use the [LIFX app](https://www.lifx.com/pages/app) to set up the lamps for each Raspberry Pi subnet.

### Specific Setup for the DuckieBot
Since the Raspberry Pi on the DuckieBot is integrated into the DuckieBot, it does not have IoT devices connected to it that would allow us to identify it as a DuckieBot.
The JASS 2021 Deployment Provider uses an empty directory at the root directory named `duckie-util`: `/duckie-util`.
The JassDeploymentProvider runs a post-discovery action and tries to find this folder. If found, the gateway is identified as a DuckieBot.

## Configure the Provider
To allow a completely automatic, you can pass a credentials file that will hold the credentials for the docker images and the Raspberry Pi based IoT gateways.
The docker images used in the JASS 2021 IoT Deployment providers are public docker images hosted in the GitHub Package Registry. Therefore no docker credentials are needed.
There is a default credentials file in this repository, `credentials.json`, that can be passed to the provider as as shown in the next section.

## Run the JASS 2021 IoT Deployment Porovider
Clone the repo and go into the provider directory. Build the provider using `swift build`. Make sure that the machine on which you run the provider is in the same network as the Raspberry Pis. You can now either:
1. Run the provider once using `swift run LifxDuckieIoTDeploymentTarget --credential-file-path credentials.json`
2. Run the evaluation script (runs the provider 10 times with redownloading docker images and 10 times without redownloading, takes quite a long time) by running: `./jass_simulation.sh credentials.json` 
Running the evaluation script, dumps the logs automatically. If you want to enable this manually set `--dump-log`. 

To generate plots of the logs, use `evaluation_processing.py` it takes two paths to directories. The first should contain the logs of the initial deployment (i.e., redownloading images), the second contains logs of the recurring deployment.

## Contributing
Contributions to this project are welcome. Please make sure to read the [contribution guidelines](https://github.com/Apodini/.github/blob/main/CONTRIBUTING.md) first.

## License
This project is licensed under the MIT License. See [License](https://github.com/Apodini/Apodini/blob/reuse/LICENSES/MIT.txt) for more information.

## Code of conduct
For our code of conduct see [Code of conduct](https://github.com/Apodini/.github/blob/main/CODE_OF_CONDUCT.md).