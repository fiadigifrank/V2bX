# Build go
FROM golang:1.21-alpine AS builder
WORKDIR /app
ENV CGO_ENABLED=0
ENV version=v3.0.2
RUN  apk --update --no-cache add tzdata ca-certificates git
RUN  git clone https://github.com/wyx2685/V2bX.git . && git checkout dev_new && \
     go build -v -o V2bX -tags "sing xray with_reality_server with_quic" -trimpath -ldflags "-X 'github.com/InazumaV/V2bX/cmd.version=$version' -s -w -buildid="


# Release
FROM  alpine
# 安装必要的工具包
RUN  apk --update --no-cache add tzdata ca-certificates git \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN mkdir /etc/V2bX
COPY --from=builder /app/V2bX /usr/local/bin
COPY --from=builder /app/example /etc/V2bX
RUN  mv /etc/V2bX/config.json /etc/V2bX/config.json

ENTRYPOINT [ "V2bX", "server"]