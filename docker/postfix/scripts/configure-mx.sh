#!/bin/sh
set -eu
. /common.sh

RSPAMD_ADDR="${RSPAMD_ADDR:-localhost:11332}"
RBL_RESTRICTIONS="${RBL_RESTRICTIONS:-}"

postconf -e "relayhost ="
postconf -e "virtual_mailbox_domains = mysql:/etc/postfix/mysql-domains.cf"
postconf -e "virtual_alias_maps = mysql:/etc/postfix/mysql-aliases.cf"
postconf -e "transport_maps = mysql:/etc/postfix/mysql-transport.cf"
postconf -e "lmtp_host_lookup = native"

postconf -e "smtpd_relay_restrictions = permit_mynetworks reject_unauth_destination"
postconf -e "smtpd_helo_required = yes"
postconf -e "smtpd_helo_restrictions = permit_mynetworks, reject_non_fqdn_helo_hostname, reject_invalid_helo_hostname"
postconf -e "smtpd_sender_restrictions = permit_mynetworks, reject_non_fqdn_sender, reject_unknown_sender_domain"

RCPT_RESTRICTIONS="permit_mynetworks, reject_non_fqdn_recipient, reject_unknown_recipient_domain, reject_unauth_destination"
if [ -n "${RBL_RESTRICTIONS}" ]; then
    RCPT_RESTRICTIONS="${RCPT_RESTRICTIONS}, ${RBL_RESTRICTIONS}"
fi
postconf -e "smtpd_recipient_restrictions = ${RCPT_RESTRICTIONS}"

postconf -e "milter_default_action = accept"
postconf -e "milter_protocol = 6"
postconf -e "smtpd_milters = inet:${RSPAMD_ADDR}"
postconf -e "non_smtpd_milters ="

postconf -e "smtpd_client_connection_count_limit = 50"
postconf -e "smtpd_client_connection_rate_limit = 30"
postconf -e "smtpd_client_message_rate_limit = 100"
