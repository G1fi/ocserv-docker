#!/bin/bash
set -e

if [ -n "$PORTS" ]; then
  echo "[INFO] Enabling port forwarding (TCP & UDP)..."

  for rule in $PORTS; do
    HOST_PORT=$(echo "$rule" | cut -d: -f1)
    CLIENT_IP=$(echo "$rule" | cut -d: -f2)
    CLIENT_PORT=$(echo "$rule" | cut -d: -f3)

    echo "[INFO] Forwarding $HOST_PORT -> $CLIENT_IP:$CLIENT_PORT"

    iptables -t nat -A PREROUTING -p tcp --dport "$HOST_PORT" -j DNAT --to-destination "$CLIENT_IP:$CLIENT_PORT"
    iptables -t nat -A PREROUTING -p udp --dport "$HOST_PORT" -j DNAT --to-destination "$CLIENT_IP:$CLIENT_PORT"

    iptables -t nat -A POSTROUTING -p tcp -d "$CLIENT_IP" --dport "$CLIENT_PORT" -j MASQUERADE
    iptables -t nat -A POSTROUTING -p udp -d "$CLIENT_IP" --dport "$CLIENT_PORT" -j MASQUERADE
  done

else
  echo "[INFO] PORTS is not set — skipping port forwarding"
fi

echo "[INFO] Enabling NAT forwarding..."
iptables -t nat -A POSTROUTING -j MASQUERADE
iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

echo "[INFO] Starting ocserv..."
exec /opt/ocserv/sbin/ocserv -f -c /etc/ocserv/ocserv.conf