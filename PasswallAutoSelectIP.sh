#!/bin/bash


#关闭passwall服务，防止测试cf被代理
/etc/init.d/haproxy stop
/etc/init.d/passwall stop

# 运行 CloudflareST 测速（自行根据需求修改参数）
./CloudflareST -tll 20

# 获取最快 IP（从 result.csv 结果文件中获取第一个 IP）
IP=$(sed -n "2,1p" result.csv | awk -F , '{print $1}')

# 判断一下是否成功获取到了最快 IP（如果没有就退出脚本）：
[[ -z “${IP}” ]] && echo “CloudflareST 测速结果 IP 数量为 0，跳过下面步骤…” && exit 0

# 修改 passwall 里对应节点的 IP（XXXXXX 就是节点 ID）
uci set passwall.XXXXX.address="${IP}"

# 最后再重启一下 passwall
uci commit passwall
/etc/init.d/haproxy restart
/etc/init.d/passwall restart
