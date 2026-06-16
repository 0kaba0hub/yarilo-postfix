#!/bin/sh
set -eu
. /common.sh

RSPAMD_ADDR="${RSPAMD_ADDR:-localhost:11332}"
OPENDKIM_ADDR="${OPENDKIM_ADDR:-}"
POSTSRSD_HOST="${POSTSRSD_HOST:-yarilo-postsrsd}"
LMTP_ADDR="${LMTP_ADDR:-}"
SASL_LOGIN_ADDR="${SASL_LOGIN_ADDR:-}"

postconf -e "relayhost ="

if [ -n "${LMTP_ADDR}" ]; then
    postconf -e "virtual_mailbox_domains = ${MAIL_DOMAINS}"
    postconf -e "virtual_transport = lmtp:inet:${LMTP_ADDR}"
    postconf -e "lmtp_host_lookup = native"
fi

postconf -e "sender_canonical_maps = socketmap:inet:${POSTSRSD_HOST}:10003:forward"
postconf -e "sender_canonical_classes = envelope_sender"
postconf -e "recipient_canonical_maps = socketmap:inet:${POSTSRSD_HOST}:10003:reverse"
postconf -e "recipient_canonical_classes = envelope_recipient,header_recipient"

postconf -e "smtpd_relay_restrictions = permit_mynetworks reject_unauth_destination"
postconf -e "smtpd_recipient_restrictions = permit_mynetworks, reject_unauth_destination"

_milters="inet:${RSPAMD_ADDR}"
if [ -n "${OPENDKIM_ADDR}" ]; then
    _milters="${_milters},inet:${OPENDKIM_ADDR}"
fi
postconf -e "milter_default_action = accept"
postconf -e "milter_protocol = 6"
postconf -e "smtpd_milters = ${_milters}"
postconf -e "non_smtpd_milters = \$smtpd_milters"

if [ -f "/run/postfix/tls/tls.crt" ]; then
    _sasl_opts=""
    if [ -n "${SASL_LOGIN_ADDR}" ]; then
        postconf -e "smtpd_sasl_type = dovecot"
        postconf -e "smtpd_sasl_path = inet:${SASL_LOGIN_ADDR}"
        postconf -e "smtpd_sasl_auth_enable = yes"
        postconf -e "smtpd_sasl_security_options = noanonymous"
        _sasl_opts="  -o smtpd_sasl_auth_enable=yes
  -o smtpd_relay_restrictions=permit_mynetworks,permit_sasl_authenticated,reject"
    else
        _sasl_opts="  -o smtpd_relay_restrictions=permit_mynetworks,reject"
    fi

    cat >> /etc/postfix/master.cf << EOF
submission inet n       -       n       -       -       smtpd
  -o syslog_name=postfix/submission
  -o smtpd_tls_security_level=encrypt
${_sasl_opts}
  -o milter_macro_daemon_name=ORIGINATING
EOF
fi
