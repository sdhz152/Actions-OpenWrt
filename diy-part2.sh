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

else if [[ $REPO_URL = *"openwrt"* && $REPO_BRANCH = "openwrt-25.12" ]] || [[ $REPO_URL = *"openwrt"* && $REPO_BRANCH = "main" ]] || [[ $REPO_URL = *"openwrt"* && $REPO_BRANCH = "v25.12.5" ]]; then
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

# --------------honk----------------
if [[ "$CACHE_TRADEMARK" = "honk" ]]; then
set -euo pipefail
# 2. 设置 Cargo 和 Rustup 的存放目录，并把 Cargo 可执行目录加入 PATH
export CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
export RUSTUP_HOME="${RUSTUP_HOME:-$HOME/.rustup}"
export PATH="$CARGO_HOME/bin:$PATH"

# 3. 从 honk 源码目录的配置文件中读取所需的 stable 和 nightly 工具链版本号
src="$(realpath package/dae-packages/honk/src)"
stable="$(python3 -c 'import sys, tomllib; print(tomllib.load(open(sys.argv[1], "rb"))["toolchain"]["channel"])' "$src/rust-toolchain.toml")"
nightly="$(python3 -c 'import sys, tomllib; print(tomllib.load(open(sys.argv[1], "rb"))["toolchain"]["channel"])' "$src/crates/honk-ebpf/rust-toolchain.toml")"

# 4. 安装 rustup，配置 stable 工具链及目标架构，并安装 eBPF 构建所需的 nightly 工具链与组件
curl --proto '=https' --tlsv1.2 -fLsS https://sh.rustup.rs | sh -s -- -y --profile minimal --default-toolchain none --no-modify-path
rustup toolchain install "$stable" --profile minimal --component rustfmt,clippy
rustup default "$stable"
rustup target add --toolchain "$stable" x86_64-unknown-linux-gnu x86_64-unknown-linux-musl
rustup toolchain install "$nightly" --profile minimal --component rust-src,llvm-tools

# 5. 读取 CI 固定版本号并下载解压 bpf-linker 到 Cargo 的 bin 目录
source "$src/.github/ci/pins.env"
mkdir -p "$CARGO_HOME/bin"
curl -fLsS "https://github.com/aya-rs/bpf-linker/releases/download/v${BPF_LINKER_VERSION}/bpf-linker-x86_64-unknown-linux-musl.tar.zst" | tar --zstd -xf - -C "$CARGO_HOME/bin"

# 6. 将环境变量和 PATH 写入 GitHub Actions 后续步骤可用的环境文件中
printf 'CARGO_HOME=%s\nRUSTUP_HOME=%s\n' "$CARGO_HOME" "$RUSTUP_HOME" >> "$GITHUB_ENV"
printf '%s\n' "$CARGO_HOME/bin" >> "$GITHUB_PATH"
# 8. 验证
rustup --version
cargo --version
rustc --version
bpf-linker --version
rustup target list --installed --toolchain "$stable"
fi
# --------------honk----------------

if ls $GITHUB_WORKSPACE/patches/0001-Revert-base-files-move-config_generate-to-preinit.patch 1> /dev/null 2>&1; then
	git apply --quiet $GITHUB_WORKSPACE/patches/0001-Revert-base-files-move-config_generate-to-preinit.patch
    echo "✅ 已成功添加  0001-Revert-base-files-move-config_generate-to-preinit.patch补丁"
else
    echo "⚠️ 警告：在 $GITHUB_WORKSPACE/patches/ 下未找到 0001-Revert-base-files-move-config_generate-to-preinit.patch 补丁文件！"
fi

if [[ $CACHE_TRADEMARK != *"AC2100-helloworld"* ]]; then
# 检查并批量复制所有 BBR3 补丁
if ls $GITHUB_WORKSPACE/patches/900-bbr3.patch 1> /dev/null 2>&1; then
    mkdir -p target/linux/generic/hack-6.12
    cp $GITHUB_WORKSPACE/patches/900-bbr3.patch target/linux/generic/hack-6.12/
    echo "✅ 已成功添加  BBR3 内核补丁到 target/linux/generic/hack-6.12/"
else
    echo "⚠️ 警告：在 $GITHUB_WORKSPACE/patches/ 下未找到 900-bbr3.patch 补丁文件！"
fi
# 写入 BBR 配置
if [[ "$REPO_URL" != *"x-wrt"* ]]; then
    echo 'net.core.default_qdisc=fq' >> package/base-files/files/etc/sysctl.conf
    echo 'net.ipv4.tcp_congestion_control=bbr' >> package/base-files/files/etc/sysctl.conf
    echo "已成功写入 BBR 配置"
fi

# 1. 精准删除禁用声明与旧的默认算法配置
sed -i '/# CONFIG_NET_SCH_FQ is not set$/d' target/linux/generic/config-6.12
sed -i '/# CONFIG_TCP_CONG_BBR is not set$/d' target/linux/generic/config-6.12
sed -i '/CONFIG_DEFAULT_TCP_CONG/d' target/linux/generic/config-6.12

# 2. 写入开启配置
cat <<EOF >> target/linux/generic/config-6.12
CONFIG_NET_SCH_FQ=y
CONFIG_TCP_CONG_BBR=y
CONFIG_DEFAULT_TCP_CONG="bbr"
CONFIG_DEFAULT_BBR=y
EOF
echo "已成功写入开启配置"
fi
