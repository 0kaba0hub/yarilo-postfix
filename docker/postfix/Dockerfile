FROM alpine:3.24
RUN apk add --no-cache \
    postfix \
    postfix-mysql \
    postfix-pcre \
    ca-certificates \
    cyrus-sasl \
    cyrus-sasl-login \
    && mkdir -p /etc/postfix/sasl /etc/sasl2
COPY scripts/entrypoint.sh /entrypoint.sh
COPY scripts/common.sh /common.sh
COPY scripts/configure-mx.sh /configure-mx.sh
COPY scripts/configure-mta.sh /configure-mta.sh
COPY scripts/configure-fwd.sh /configure-fwd.sh
RUN chmod +x /entrypoint.sh /configure-mx.sh /configure-mta.sh /configure-fwd.sh
ENTRYPOINT ["/entrypoint.sh"]
