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
if [[ "$CACHE_TRADEMARK" = "honk" ]]; then
# 1. 提前设置当前会话环境变量与固定版本
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"
export PATH="$CARGO_HOME/bin:$PATH"
export stable="1.99.1"

# 3. 安装 rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
  | sh -s -- -y --profile minimal --default-toolchain none --no-modify-path

# 4. 安装 1.99.1 工具链、设为默认并添加 x86_64 目标
rustup toolchain install "$stable" --profile minimal --component rustfmt,clippy
rustup default "$stable"
rustup target add --toolchain "$stable" x86_64-unknown-linux-gnu x86_64-unknown-linux-musl

# 5. 安装 eBPF 所需的 nightly 工具链及组件
nightly="$(python3 -c 'import sys,tomllib;print(tomllib.load(open(sys.argv[1],"rb"))["toolchain"]["channel"])' "package/dae-packages/honk/src/crates/honk-ebpf/rust-toolchain.toml")"
rustup toolchain install "$nightly" --profile minimal --component rust-src,llvm-tools

# 6. 安装 cargo-binstall 与 bpf-linker
curl -L --proto '=https' --tlsv1.2 -sSf \
  https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
cargo binstall -y bpf-linker

# 7. 安装 go（先清理旧目录避免残留）
wget -qnc https://go.dev/dl/go1.27.4.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.27.4.linux-amd64.tar.gz
cat <<'EOF' >> "$HOME/.bashrc"

# Rust & eBPF 环境变量
export PATH="/usr/local/go/bin:$PATH"
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"
export PATH="$CARGO_HOME/bin:$PATH"
export stable="1.99.1"
EOF
source "$HOME/.bashrc"

# 导出环境变量给 GitHub Actions 后续的 Step
if [ -n "${GITHUB_PATH:-}" ]; then
  echo "/usr/local/go/bin" >> "$GITHUB_PATH"
  echo "$CARGO_HOME/bin" >> "$GITHUB_PATH"
fi

if [ -n "${GITHUB_ENV:-}" ]; then
  echo "CARGO_HOME=$CARGO_HOME" >> "$GITHUB_ENV"
  echo "RUSTUP_HOME=$RUSTUP_HOME" >> "$GITHUB_ENV"
fi

# 8. 验证
go version
rustup --version
cargo --version
rustc --version
bpf-linker --version
rustup target list --installed --toolchain "$stable"
echo "安装完成"
fi

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
