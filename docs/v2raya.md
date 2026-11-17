# ------------mosdns开启---先更新下数据库------------

防止 DNS 泄漏

# 远程 DNS 服务器

8.8.8.8, 1.1.1.1, 9.9.9.9，选其它在v2ray的规则端口的分流模式-->RoutingA下定义

# ----------------v2raya-----------------

1---第一项选启用: 分流规则-----开启ip转发

# ---------------------------------------

2--方式选---tproxy--------

# ---------------------------------------

3----规则端口的分流模式-------选-------RoutingA设置------------- 

port(5335, 53) -> direct
domain(contains:alidns) -> direct
ip(224.0.0.0/3, 'ff00::/8', 223.5.5.5, 223.6.6.6, '2400:3200::1', '2400:3200:baba::1') -> direct
domain(domain:mail.qq.com)->direct
domain(geosite:category-scholar-!cn, geosite:category-scholar-cn)->direct
domain(geosite:cn)->direct
ip(geoip:private, geoip:cn)->direct
domain(contains:opendns, contains:cloudflare, contains:quad9) -> proxy
ip(208.67.222.222, 8.8.8.8, 8.8.4.4, 1.1.1.1, 1.0.0.1, 9.9.9.9, 149.112.112.112, 208.67.220.220, '2606:4700:4700::1111', '2001:4860:4860::8888', '2620:fe::fe') -> proxy
source(ipv4) -> proxy
# 3. 核心底线：局域网内除此以外的所有设备及流量全部强制直连
default: direct

# 4---------防止DNS污染---------------------

选---自定义高级设置-------------------

# DNS 设置-----域名查询服务器填入

127.0.0.1:5335 -> direct

# 国外域名查询服务器填入

127.0.0.1:5335 -> direct

# ---------------------------------------
