# Passwall-AutoSelect-CloudFIareIP

## 该脚本作用为使用XIU2大佬的CF优选IP工具-CloudflareSpeedTest-，挑选出优选IP并自动替换到PassWall服务的节点里。

PS:

1、该脚本针对OpenWRT的PassWall服务，用其他服务的同学请自行修改。

### 脚本访问地址：https://raw.githubusercontent.com/YosenFree/Passwall-AutoSelect-CloudFIareIP/main/PasswallAutoSelectIP.sh

### 一、脚本代码

```shell
#!/bin/bash

# 进入CloudflareST文件目录（请根据个人实际目录进行修改）
cd /root/CloudflareST/

# 关闭passwall服务，防止测试cf被代理
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
```
### 二、设置OpenWRT计划任务
```
0 03 * * * bash /root/CloudflareST/autoselectip.sh > /dev/null
```

#### 时程表的格式如下:
```
f1 f2 f3 f4 f5 Program

其中 f1 是表示分钟，f2 表示小时，f3 表示一个月份中的第几日，f4 表示月份，f5 表示一个星期中的第几天。
Program 表示要执行的命令。

0 03 * * * 表示每天的凌晨三点
```
#### 如果需要重启cron 则：
```
service cron restart
```
***
***
## 附：
附上XIU2大佬的项目地址和使用方法：https://github.com/XIU2/CloudflareSpeedTest

**如果是第一次使用，则建议创建新文件夹（后续更新时，跳过该步骤）**

mkdir CloudflareST

**进入文件夹（后续更新，只需要从这里重复下面的下载、解压命令即可）**

cd CloudflareST

**下载 CloudflareST 压缩包（自行根据需求替换 URL 中 [版本号] 和 [文件名]）**

wget -N https://github.com/XIU2/CloudflareSpeedTest/releases/download/v2.2.3/CloudflareST_linux_amd64.tar.gz

**如果你是在国内服务器上下载，那么请使用下面这几个镜像加速：**

wget -N https://download.fastgit.org/XIU2/CloudflareSpeedTest/releases/download/v2.2.3/CloudflareST_linux_amd64.tar.gz

wget -N https://ghproxy.com/https://github.com/XIU2/CloudflareSpeedTest/releases/download/v2.2.3/CloudflareST_linux_amd64.tar.gz

**如果下载失败的话，尝试删除 -N 参数（如果是为了更新，则记得提前删除旧压缩包 rm CloudflareST_linux_amd64.tar.gz ）**

**解压（不需要删除旧文件，会直接覆盖，自行根据需求替换 文件名）**

tar -zxf CloudflareST_linux_amd64.tar.gz

**赋予执行权限**

chmod +x CloudflareST
