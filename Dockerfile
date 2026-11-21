# 第一阶段：从官方 teddysun/xray 镜像取出 xray 二进制
# 该镜像没有 shell，不能直接拿来跑，所以只用它做构建源
FROM teddysun/xray:26.10.31 AS xray

# 第二阶段：Alpine 基础镜像，拷入二进制后再运行
FROM alpine:3.20
RUN apk add --no-cache ca-certificates
COPY --from=xray /usr/bin/xray /usr/bin/xray
COPY --from=xray /usr/share/xray /usr/share/xray
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 3000
ENTRYPOINT ["/entrypoint.sh"]
