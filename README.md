# AWG standalone server deployment
This set of scripts deploys an Amnezia WireGuard service from the [Amnesia VPN Suite](https://github.com/amnezia-vp) on a standalone Linux (Ubuntu/Debian) server (VPS or whatever).  
Amnezia VPN is a suite of many VPN services (WG, AWG, OpenVPN, Cloack, ShadowSocks)
and it comes with the installer that require **root access** to your server.  
I'm sure this has been done to make deployment as easy as possible for unqualified users. And they claim that the root passwords wouldn't be compromise in any shape of form. And you always can check Amnezia's sourcecode by yourself to make sure it doesn't.  
But even if a trust case is negligible for someone (for me) there is always another reason such as - lets assume I don't need all the corks and features and I need AWG service only



## prerequisites

scripts were made and tested on Ubuntu 20.04

* docker should be installed
* user should be in sudoers

## scripts
### install server
**Note:** should be run once and never again

First fill up the **.env** file
then run a command
```sh 
user@srv:~/awg$ source .env
```

next just run all the scripts in order
* bash 1.\<tab>  
* bash 2.\<tab>  
* bash 3.\<tab>  
* bash 4.\<tab>  
  
\<tab> means autocompetion

this sets of scripts builds and runs **awg** docker container

make sure it is up and running by issuing a command:  
  *docker ps*

**Note:** Initial user has been created  
just copy *wg_client.conf* to your device or scan QR code from *wg_client.png*



### create new clients
**Note:** the script uses files *wg_psk.keys* and *wg_server_public_key.key* as well as *ENV* variables so do not delete them

To create a new user first choose an IP address from the WIREGUARD_SUBNET_IP subnet that isn't in use yet

now just enter 
```sh 
user@srv:~/awg$ bash configure_client.sh <IP>
```

Three files would be created (or renewed):  
1. wg_client.conf
2. wg_client.png
3. wg_add_client_key_to_a_server.cmd

I'm sure you know what the first two files for  
and the last one contains a command you have to execute to add a clients pubkey to a server


