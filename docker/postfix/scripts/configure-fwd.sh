#!/bin/sh
set -eu
. /common.sh

RSPAMD_ADDR="${RSPAMD_ADDR:-localhost:11332}"
POSTSRSD_ADDR="${POSTSRSD_ADDR:-yarilo-postsrsd:10001}"
POSTSRSD_REVERSE_ADDR="${POSTSRSD_REVERSE_ADDR:-yarilo-postsrsd:10002}"
LMTP_ADDR="${LMTP_ADDR:-}"

postconf -e "relayhost ="

if [ -n "${LMTP_ADDR}" ]; then
    postconf -e "virtual_mailbox_domains = ${MAIL_DOMAINS}"
    postconf -e "virtual_transport = lmtp:inet:${LMTP_ADDR}"
    postconf -e "lmtp_host_lookup = native"
fi

postconf -e "sender_canonical_maps = tcp:${POSTSRSD_ADDR}"
postconf -e "sender_canonical_classes = envelope_sender"
postconf -e "recipient_canonical_maps = tcp:${POSTSRSD_REVERSE_ADDR}"
postconf -e "recipient_canonical_classes = envelope_recipient,header_recipient"

postconf -e "smtpd_relay_restrictions = permit_mynetworks reject_unauth_destination"
postconf -e "smtpd_recipient_restrictions = permit_mynetworks, reject_unauth_destination"

postconf -e "milter_default_action = accept"
postconf -e "milter_protocol = 6"
postconf -e "smtpd_milters = inet:${RSPAMD_ADDR}"
postconf -e "non_smtpd_milters = inet:${RSPAMD_ADDR}"
