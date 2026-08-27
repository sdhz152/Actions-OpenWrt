#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
# sed -i 's/KERNEL_PATCHVER:=5.15/KERNEL_PATCHVER:=5.10/g' target/linux/x86/Makefile
if [[ $REPO_URL = *"immortalwrt"* || $REPO_URL = *"coolsnowwolf"* ]]; then
   sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
   echo "============================="
   echo "diy-part2扩展自定义第一项设置完成"
   echo "============================="

else if [[ $REPO_URL = *"x-wrt"* ]]; then
   sed -i 's/192.168.15.1/192.168.2.1/g' package/base-files/files/bin/config_generate
   sed -i "s/timezone='UTC'/timezone='CST-8'/" package/base-files/files/bin/config_generate
   sed -i "/timezone='CST-8'/a \ \ \ \ \ \ \ \ set system.@system[-1].zonename='Asia/Shanghai'" package/base-files/files/bin/config_generate
   sed -i "s/add_list system.ntp.server='0.openwrt.pool.ntp.org'/add_list system.ntp.server='ntp.aliyun.com'/" package/base-files/files/bin/config_generate
   sed -i "s/add_list system.ntp.server='1.openwrt.pool.ntp.org'/add_list system.ntp.server='time1.cloud.tencent.com'/" package/base-files/files/bin/config_generate
   sed -i "s/add_list system.ntp.server='2.openwrt.pool.ntp.org'/add_list system.ntp.server='time.ustc.edu.cn'/" package/base-files/files/bin/config_generate
   sed -i "s/add_list system.ntp.server='3.openwrt.pool.ntp.org'/add_list system.ntp.server='cn.pool.ntp.org'/" package/base-files/files/bin/config_generate
   echo "============================="
   echo "diy-part2扩展自定义第二项设置完成"
   echo "============================="

else if [[ $REPO_URL = *"openwrt"* && $REPO_BRANCH = "openwrt-25.12" ]] || [[ $REPO_URL = *"openwrt"* && $REPO_BRANCH = "main" ]]; then
   sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
   sed -i "s/timezone='GMT0'/timezone='CST-8'/" package/base-files/files/bin/config_generate
   sed -i "s/zonename='UTC'/zonename='Asia\/Shanghai'/" package/base-files/files/bin/config_generate
   sed -i "s/add_list system.ntp.server='0.openwrt.pool.ntp.org'/add_list system.ntp.server='ntp.aliyun.com'/" package/base-files/files/bin/config_generate
   sed -i "s/add_list system.ntp.server='1.openwrt.pool.ntp.org'/add_list system.ntp.server='time1.cloud.tencent.com'/" package/base-files/files/bin/config_generate
   sed -i "s/add_list system.ntp.server='2.openwrt.pool.ntp.org'/add_list system.ntp.server='time.ustc.edu.cn'/" package/base-files/files/bin/config_generate
   sed -i "s/add_list system.ntp.server='3.openwrt.pool.ntp.org'/add_list system.ntp.server='cn.pool.ntp.org'/" package/base-files/files/bin/config_generate
   echo "============================="
   echo "diy-part2扩展自定义第三项设置完成"
   echo "============================="

else
   sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
   sed -i "s/timezone='UTC'/timezone='CST-8'/" package/base-files/files/bin/config_generate
   sed -i "/timezone='CST-8'/a \ \ \ \ \ \ \ \ set system.@system[-1].zonename='Asia/Shanghai'" package/base-files/files/bin/config_generate
   sed -i "s/add_list system.ntp.server='0.openwrt.pool.ntp.org'/add_list system.ntp.server='ntp.aliyun.com'/" package/base-files/files/bin/config_generate
   sed -i "s/add_list system.ntp.server='1.openwrt.pool.ntp.org'/add_list system.ntp.server='time1.cloud.tencent.com'/" package/base-files/files/bin/config_generate
   sed -i "s/add_list system.ntp.server='2.openwrt.pool.ntp.org'/add_list system.ntp.server='time.ustc.edu.cn'/" package/base-files/files/bin/config_generate
   sed -i "s/add_list system.ntp.server='3.openwrt.pool.ntp.org'/add_list system.ntp.server='cn.pool.ntp.org'/" package/base-files/files/bin/config_generate
   echo "============================="
   echo "diy-part2扩展自定义第四项设置完成"
   echo "============================="
      fi
   fi
fi
# 添加编译日期
sed -i 's/IMG_PREFIX:=/IMG_PREFIX:=$(BUILD_DATE_PREFIX)-/g' ./include/image.mk
sed -i '/DTS_DIR:=$(LINUX_DIR)/a\BUILD_DATE_PREFIX := $(shell date +'%F')' ./include/image.mk
if [[ "$REPO_URL" != *"x-wrt"* ]]; then
    echo 'net.core.default_qdisc=fq' >> package/base-files/files/etc/sysctl.conf
    echo 'net.ipv4.tcp_congestion_control=bbr' >> package/base-files/files/etc/sysctl.conf
    echo "已成功写入 BBR 配置"
fi

if ls $GITHUB_WORKSPACE/patches/0001-TCH-base-files-generate-default-network-config-after.patch 1> /dev/null 2>&1; then
	git apply --quiet $GITHUB_WORKSPACE/patches/0001-TCH-base-files-generate-default-network-config-after.patch
    echo "✅ 已成功添加  0001-TCH-base-files-generate-default-network-config-after.patch补丁"
else
    echo "⚠️ 警告：在 $GITHUB_WORKSPACE/patches/ 下未找到 0001-TCH-base-files-generate-default-network-config-after.patch 补丁文件！"
fi