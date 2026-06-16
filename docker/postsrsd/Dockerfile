FROM alpine:3.23 AS fetch
ARG POSTSRSD_VERSION=2.1.0
RUN apk add --no-cache ca-certificates wget \
    && wget -q "https://github.com/roehling/postsrsd/releases/download/${POSTSRSD_VERSION}/postsrsd-x86_64-musl.tar.gz" -O /tmp/postsrsd.tar.gz \
    && tar xzf /tmp/postsrsd.tar.gz -C / --strip-components=1 \
    && rm /tmp/postsrsd.tar.gz

FROM alpine:3.23
RUN apk add --no-cache ca-certificates
COPY --from=fetch /usr/local/sbin/postsrsd /usr/local/sbin/postsrsd
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh /usr/local/sbin/postsrsd
EXPOSE 10001 10002
ENTRYPOINT ["/entrypoint.sh"]
