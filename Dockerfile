FROM alpine:latest AS builder

RUN apk add --no-cache curl tar jq xz bzip2

WORKDIR /root/download

ARG MATCH_FILE_NAME=linux-musl-x64
ARG API_URL=https://api.github.com/repos/cnbatch/kcptube/releases/latest

RUN echo "[*] Fetching latest release info..." && \
    download_url=$(curl -s "$API_URL" | jq -r '.assets[] | select(.name | test(".*'"$MATCH_FILE_NAME"'.*\\.tar\\.bz2$")) | .browser_download_url') && \
    echo "[*] Download URL: $download_url" && \
    curl -L "$download_url" -o kcptube.tar.bz2 && \
    mkdir -p /root/download/kcptube && \
    tar -xjf kcptube.tar.bz2 -C /root/download/kcptube && \
    kcptube_bin=$(find /root/download/kcptube -type f -name "kcptube*") && \
    mv "$kcptube_bin" /root/download/kcptube/kcptube && \
    chmod a+x /root/download/kcptube/kcptube && \
    rm kcptube.tar.bz2

FROM alpine:latest

WORKDIR /root

RUN apk add --no-cache tzdata

RUN apk add --no-cache bzip2

ENV TZ=Asia/Shanghai

COPY --from=builder /root/download/kcptube/kcptube /root/kcptube/kcptube

RUN chmod a+x /root/kcptube/kcptube

CMD ["/root/kcptube/kcptube", "/root/kcptube/kcptube.conf"]
