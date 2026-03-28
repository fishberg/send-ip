#!/usr/bin/env bash

FILENAME="$(date +%s)"
LOGDIR="${LOGDIR:-/send-ip/logs}"
FILEPATH="${LOGDIR}/${FILENAME}"
IFNAME="${IFNAME:-wlan0}"
SENDTO="${SENDTO:-SEND-IP-DESTINATION}"

ip address show ${IFNAME} > ${FILEPATH}
rsync -azP ${LOGDIR}/ ${SENDTO}:.
