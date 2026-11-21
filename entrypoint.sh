#!/bin/sh
# 启动时用 Cloady 环境变量生成 Xray 配置（UUID 与 WS 路径不进仓库）
set -eu
: "${CLIENT_ID:?CLIENT_ID 环境变量未设置}"
: "${WS_PATH:=/ws}"
case "$WS_PATH" in
  /*) ;;
  *) WS_PATH="/$WS_PATH" ;;
esac
mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": {"loglevel": "warning"},
  "inbounds": [
    {
      "port": 3000,
      "protocol": "vless",
      "settings": {
        "clients": [{"id": "$CLIENT_ID"}],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {"path": "$WS_PATH"}
      }
    }
  ],
  "outbounds": [{"protocol": "freedom"}]
}
EOF
exec /usr/bin/xray -config /etc/xray/config.json
