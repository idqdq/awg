#/bin/bash
# creates wg_client.conf and a corresponding QR code .png 
# it must be run with a mandatory argument: IP address of a new client

if [[ $# -eq 0 ]] ; then
    echo "a new client's IP address expected"
    exit 1
fi


WIREGUARD_CLIENT_PRIVATE_KEY=$(wg genkey)
WIREGUARD_CLIENT_PUBLIC_KEY=$(echo $WIREGUARD_CLIENT_PRIVATE_KEY | wg pubkey)
echo $WIREGUARD_CLIENT_PUBLIC_KEY > wg_client_public_key.key
WIREGUARD_PSK=$(cat wg_psk.key)
WIREGUARD_SERVER_PUBLIC_KEY=$(cat wg_server_public_key.key)

cat > wg_client.conf <<EOF
[Interface]
Address = $1/32
DNS = $PRIMARY_DNS, $SECONDARY_DNS
PrivateKey = $WIREGUARD_CLIENT_PRIVATE_KEY
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
PublicKey = $WIREGUARD_SERVER_PUBLIC_KEY
PresharedKey = $WIREGUARD_PSK
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = $SERVER_IP_ADDRESS:$AWG_SERVER_PORT
PersistentKeepalive = 25
EOF

if [ -f /usr/bin/qrencode ]; then (/usr/bin/qrencode -t PNG -o wg_client.png < wg_client.conf); fi

echo "docker exec -it awg wg set wg0 peer $WIREGUARD_CLIENT_PUBLIC_KEY allowed-ips $1/32" > wg_add_client_key_to_a_server.cmd

