#!/bin/bash
# this scripts generate keys and configs for a server and a client
# issue source ./env command first

WIREGUARD_SERVER_PRIVATE_KEY=$(wg genkey)
echo $WIREGUARD_SERVER_PRIVATE_KEY > wg_server_private_key.key

WIREGUARD_SERVER_PUBLIC_KEY=$(echo $WIREGUARD_SERVER_PRIVATE_KEY | wg pubkey)
echo $WIREGUARD_SERVER_PUBLIC_KEY > wg_server_public_key.key

WIREGUARD_PSK=$(wg genpsk)
echo $WIREGUARD_PSK > wg_psk.key

# the very first client config so the server would be aware of on a first run
source ./configure_client.sh $WIREGUARD_CLIENT_IP

cat > wg0.conf <<EOF
[Interface]
PrivateKey = $WIREGUARD_SERVER_PRIVATE_KEY
Address = $WIREGUARD_SUBNET_IP/$WIREGUARD_SUBNET_CIDR
ListenPort = $AWG_SERVER_PORT
Jc = $JUNK_PACKET_COUNT
Jmin = $JUNK_PACKET_MIN_SIZE
Jmax = $JUNK_PACKET_MAX_SIZE
S1 = $INIT_PACKET_JUNK_SIZE
S2 = $RESPONSE_PACKET_JUNK_SIZE
H1 = $INIT_PACKET_MAGIC_HEADER
H2 = $RESPONSE_PACKET_MAGIC_HEADER
H3 = $UNDERLOAD_PACKET_MAGIC_HEADER
H4 = $TRANSPORT_PACKET_MAGIC_HEADER

[Peer]
PublicKey = $WIREGUARD_CLIENT_PUBLIC_KEY
PresharedKey = $WIREGUARD_PSK
AllowedIPs = $WIREGUARD_CLIENT_IP/32, ::/0
EOF


cat > start.sh << EOF

#!/bin/bash

# This scripts copied from Amnezia client to Docker container to /opt/amnezia and launched every time container starts

echo "Container startup"

# kill daemons in case of restart
wg-quick down /opt/amnezia/awg/wg0.conf

# start daemons if configured
if [ -f /opt/amnezia/awg/wg0.conf ]; then (wg-quick up /opt/amnezia/awg/wg0.conf); fi

# Allow traffic on the TUN interface.
iptables -A INPUT -i wg0 -j ACCEPT
iptables -A FORWARD -i wg0 -j ACCEPT
iptables -A OUTPUT -o wg0 -j ACCEPT

# Allow forwarding traffic only from the VPN.
iptables -A FORWARD -i wg0 -o eth0 -s $WIREGUARD_SUBNET_IP/$WIREGUARD_SUBNET_CIDR -j ACCEPT
iptables -A FORWARD -i wg0 -o eth1 -s $WIREGUARD_SUBNET_IP/$WIREGUARD_SUBNET_CIDR -j ACCEPT

iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -t nat -A POSTROUTING -s $WIREGUARD_SUBNET_IP/$WIREGUARD_SUBNET_CIDR -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $WIREGUARD_SUBNET_IP/$WIREGUARD_SUBNET_CIDR -o eth1 -j MASQUERADE

tail -f /dev/null
EOF
