#!/bin/sh
MAIL_DOMAIN="${MAIL_DOMAIN:-example.com}"
MAIL_HOSTNAME="${MAIL_HOSTNAME:-mail.example.com}"
MAIL_MYNETWORKS="${MAIL_MYNETWORKS:-127.0.0.0/8 10.0.0.0/8}"
MAIL_DOMAINS="${MAIL_DOMAINS:-${MAIL_DOMAIN}}"

postconf -e "myhostname = ${MAIL_HOSTNAME}"
postconf -e "smtp_helo_name = ${MAIL_HOSTNAME}"
postconf -e "mydomain = ${MAIL_DOMAIN}"
postconf -e "myorigin = ${MAIL_DOMAIN}"
postconf -e "inet_interfaces = all"
postconf -e "inet_protocols = ipv4"
postconf -e "mydestination = localhost"
postconf -e "biff = no"
postconf -e "append_dot_mydomain = no"
postconf -e "maillog_file = /dev/stdout"
postconf -e "mynetworks = ${MAIL_MYNETWORKS}"
postconf -e "smtpd_banner = \$myhostname ESMTP"

postconf -e "smtp_tls_security_level = may"
postconf -e "smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt"
postconf -e "smtp_tls_loglevel = 1"

if [ -f "/run/postfix/tls/tls.crt" ]; then
    postconf -e "smtpd_tls_cert_file = /run/postfix/tls/tls.crt"
    postconf -e "smtpd_tls_key_file = /run/postfix/tls/tls.key"
    postconf -e "smtpd_tls_security_level = may"
    postconf -e "smtpd_tls_loglevel = 1"
fi
