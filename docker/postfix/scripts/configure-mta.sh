#!/bin/sh
set -eu
. /common.sh

RSPAMD_ADDR="${RSPAMD_ADDR:-localhost:11332}"
SASL_LOGIN_ADDR="${SASL_LOGIN_ADDR:-yarilo-sasl-login:12325}"

postconf -e "relayhost ="
postconf -e "virtual_mailbox_domains = mysql:/etc/postfix/mysql-domains.cf"
postconf -e "virtual_alias_maps = mysql:/etc/postfix/mysql-aliases.cf"
postconf -e "transport_maps = hash:/etc/postfix/transport"
postconf -e "sender_dependent_default_transport_maps = mysql:/etc/postfix/mysql-sender-transport.cf, \$transport_maps"
postconf -e "lmtp_host_lookup = native"

postconf -e "smtpd_sasl_type = dovecot"
postconf -e "smtpd_sasl_path = inet:${SASL_LOGIN_ADDR}"
postconf -e "smtpd_sasl_auth_enable = yes"
postconf -e "smtpd_sasl_security_options = noanonymous"
postconf -e "smtpd_sasl_local_domain = ${MAIL_DOMAIN}"

postconf -e "smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated reject"
postconf -e "smtpd_sender_restrictions = permit_mynetworks, reject_authenticated_sender_login_mismatch"
postconf -e "smtpd_sender_login_maps = regexp:/etc/postfix/sender_login_maps"

cat > /etc/postfix/sender_login_maps << 'EOF'
/^(.+)@(.+)$/ ${1}@${2}
/^(.+)$/       ${1}
EOF

postconf -e "milter_default_action = accept"
postconf -e "milter_protocol = 6"
postconf -e "smtpd_milters = inet:${RSPAMD_ADDR}"
postconf -e "non_smtpd_milters = inet:${RSPAMD_ADDR}"

if [ -f "/run/postfix/tls/tls.crt" ]; then
    cat >> /etc/postfix/master.cf << EOF
submission inet n       -       n       -       -       smtpd
  -o syslog_name=postfix/submission
  -o smtpd_tls_security_level=encrypt
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_relay_restrictions=permit_sasl_authenticated,reject
  -o milter_macro_daemon_name=ORIGINATING
EOF
fi
