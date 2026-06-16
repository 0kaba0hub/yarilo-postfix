FROM alpine:3.23
RUN apk add --no-cache \
    postfix \
    postfix-pcre \
    ca-certificates
COPY scripts/entrypoint.sh /entrypoint.sh
COPY scripts/common.sh /common.sh
COPY scripts/configure-mx.sh /configure-mx.sh
COPY scripts/configure-mta.sh /configure-mta.sh
COPY scripts/configure-fwd.sh /configure-fwd.sh
RUN chmod +x /entrypoint.sh /configure-mx.sh /configure-mta.sh /configure-fwd.sh
ENTRYPOINT ["/entrypoint.sh"]
