#!/bin/sh
set -eu
. /common.sh

RSPAMD_ADDR="${RSPAMD_ADDR:-localhost:11332}"
POSTSRSD_HOST="${POSTSRSD_HOST:-yarilo-postsrsd}"
LMTP_ADDR="${LMTP_ADDR:-}"

postconf -e "relayhost ="

if [ -n "${LMTP_ADDR}" ]; then
    postconf -e "virtual_mailbox_domains = ${MAIL_DOMAINS}"
    postconf -e "virtual_transport = lmtp:inet:${LMTP_ADDR}"
    postconf -e "lmtp_host_lookup = native"
fi

postconf -e "smtp_generic_maps = socketmap:inet:${POSTSRSD_HOST}:10003:forward"
postconf -e "recipient_canonical_maps = socketmap:inet:${POSTSRSD_HOST}:10003:reverse"
postconf -e "recipient_canonical_classes = envelope_recipient,header_recipient"

postconf -e "smtpd_relay_restrictions = permit_mynetworks reject_unauth_destination"
postconf -e "smtpd_recipient_restrictions = permit_mynetworks, reject_unauth_destination"

postconf -e "milter_default_action = accept"
postconf -e "milter_protocol = 6"
postconf -e "smtpd_milters = inet:${RSPAMD_ADDR}"
postconf -e "non_smtpd_milters = \$smtpd_milters"
