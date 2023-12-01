# AWG standalone server deployment
This set of scripts deploy amnezia wireguard service on a standalone server (VPS or whatever).
Amnezia VPN is a combine of many VPN services (WG, AWG, OpenVPN, Cloack, ShadowSocks)
and it comes with the installer that require **root access** to your server
They claim root passwords wouldn't be compromise and you always can check Amnezia's sourcecode https://github.com/amnezia-vpn by yourself to make sure it doesn't? but you know? I'm not that good in code audit and from the other hand I need AWG only

I like WG and AWG is a modified WG that is way more resistant to block

## scripts

First fill up the **1.env** file
then run a command
```sh 
user@srv:~/awg$ source 1.env
```

next run all scripts in order like 
bash 2.<tab>
bash 3.<tab>
bash 4.<tab>
<tab> means autocompetion

