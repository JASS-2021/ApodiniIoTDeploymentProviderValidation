# ApodiniIoTDeploymentProviderValidation

## Setup
The evaluation has been conducted with a total of **3** Raspberry Pis (A, B, C), to which are 3 LIFX lamps and 1 DuckieBot connected such that:

 - 2 LIFX lamps are to Pi A
 - 1 LIFX lamp are to Pi B 
 - 1 DuckieBot with Pi C (a DuckieBot consists of a Raspberry Pi: Pi C refers to this pi)

### General Setup

 1. Boot all pis using [this image](https://github.com/fa21-collaborative-drone-interactions/BuoyAP). This should pre-configure access point, docker, etc.)
 2. Download and start avahi by:
     I. sudo apt-get install avahi-utils avahi-daemon
     II. edit /etc/avahi/avahi-daemon.conf
         `publish-hinfo=yes`
         `publish-workstation=yes`
    III. sudo systemctl enable avahi-daemon.service
    IV. sudo systemctl start avahi-daemon.service
    Alternatively you can also download and run [this script](https://github.com/Apodini/ApodiniIoTDeploymentProvider/blob/develop/scripts/setup-IoT.sh)
3. Enable keyless ssh login by running: 
    `ssh-copy-id username@ipaddress`
4. (Optional) In my tests I sometimes had the issue that the free space was always around 7-8gb even with bigger sd cards. If you notice something similar, I can recommend [this guide]

### Specific Setup for the LIFX Pis
When booting the pis with the aforementioned image, the pis automatically open an access point. To connect the lamps to them, I connected to the access point with my mobile phone and used the LIFX app to setup the lamps for each sub net. The image also automatically run a docker container on startup, so might want to stop&remove that before running the provider. 

### Specific Setup for the DuckieBot
The DuckieBot represents a special case. Since the Raspberry Pi is integrated into the DuckieBot, it does not have IoT devices connected to it that would allow us to identify it as a DuckieBot. Therefore, we need a small workaround.
On Pi C (i.e., the one of the DuckieBot), create an empty directory unter root: `/duckie-util`. The JassDeploymentProvider runs a post discovery action and looks for this folder. If found, the gateway is identified as a DuckieBot.

### Configure the Provider
To allow a completely automatic, you can pass a credentials file that will hold the credentials for the docker images and the gateways. Please reach out to me for that and I will send it you privately, since some of the images are in my personal repo. 

In `LifxDeployCommand.swift` file, the docker infos for the LIFX post discovery actions need to be manually updated with the correct credentials. I will send them to you as well and you need to adjust them manually in the code. 

### Run the Provider
Clone the repo and go into the provider directory. Build the provider using `swift build`. Make sure that the machine on which you run the provider is in the same network as the Raspberry Pis. You can now either:
1. Run the provider once using `swift run LifxDuckieIoTDeploymentTarget --credential-file-path PATH_TO_FILE`
2. Run the evaluation script (runs the provider 10 times with redownloading docker images and 10 times without redownloading, takes quite a long time) by running: `./jass_simulation.sh PATH_TO_CREDENTIAL_FILE`.
Running the evaluation script, dumps the logs automatically. If you want to enable this manually set `--dump-log`. 

To generate plots of the logs, use `evaluation_processing.py` it takes two paths to directories. The first should contain the logs of the initial deployment (i.e., redownloading images), the second contains logs of the recurring deployment.

## Last Remarks
I hope this clarifies setup and usage of the provider. If you encounter any problems or run into some issues, feel free to reach out to me.

