#!/bin/sh
set -e

DOMAIN="${SRS_DOMAIN:-example.com}"
SECRET="${SRS_SECRET:-changeme}"

cat > /etc/postsrsd.conf <<CONF
domains = ["${DOMAIN}"]
secrets = ["${SECRET}"]
forward-port = 10001
reverse-port = 10002
CONF

exec /usr/local/sbin/postsrsd
