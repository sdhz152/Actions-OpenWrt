#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
# echo 'src-git helloworld https://github.com/fw876/helloworld;main' >>feeds.conf.default
# echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> "feeds.conf.default"
# echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main" >> "feeds.conf.default"
# echo "src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main" >> "feeds.conf.default"
# echo "src-git pack https://github.com/sdhz153/packages.git;master" >> "feeds.conf.default"
# echo "src-git sbwml https://github.com/sbwml/luci-app-mosdns;v5" >> "feeds.conf.default"

# svn co https://github.com/kenzok8/small-package/trunk/redsocks2 package/diy/redsocks2
# svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/diy/luci-app-openclash
# svn co https://github.com/kenzok8/small-package/trunk/luci-app-smartdns package/diy/luci-app-smartdns
# svn co https://github.com/kenzok8/small-package/trunk/smartdns package/diy/smartdns
# svn co https://github.com/sbwml/luci-app-mosdns/trunk/luci-app-mosdns package/diy/luci-app-mosdns
# svn co https://github.com/sbwml/luci-app-mosdns/trunk/mosdns package/diy/mosdns
# svn co https://github.com/sbwml/luci-app-mosdns/trunk/v2dat package/diy/v2dat
# svn co https://github.com/kenzok8/small-package/trunk/ipt2socks package/diy/ipt2socks
# svn co https://github.com/kenzok8/small-package/trunk/microsocks package/diy/microsocks
# svn co https://github.com/kenzok8/small-package/trunk/dns2socks package/diy/dns2socks
# svn co https://github.com/kenzok8/small-package/trunk/pdnsd-alt package/diy/pdnsd-alt
