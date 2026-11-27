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
## dae/honk
rm -rf feeds/luci/applications/luci-app-dae \
       feeds/luci/applications/luci-app-honk \
       feeds/packages/net/dae \
       feeds/packages/net/honk

if [ -d "package/dae-packages" ]; then
  git -C package/dae-packages pull
  git -C package/dae-packages/dae/src pull
  git -C package/dae-packages/honk/src pull
else
  git clone https://github.com/daeuniverse/openwrt-packages package/dae-packages
  git clone --recurse-submodules https://github.com/daeuniverse/dae package/dae-packages/dae/src
  git clone --recurse-submodules https://github.com/daeuniverse/honk package/dae-packages/honk/src
fi

(
  set -euo pipefail
  [[ "$(uname -s)" == Linux && "$(uname -m)" == x86_64 ]]

  src="$(realpath package/dae-packages/honk/src)"
  export CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
  export RUSTUP_HOME="${RUSTUP_HOME:-$HOME/.rustup}"
  export PATH="$CARGO_HOME/bin:$PATH"

  target_text="$(python3 - <<'PY_TARGETS' package/dae-packages/honk/build.sh
import pathlib, re, sys
text = pathlib.Path(sys.argv[1]).read_text()
section = re.search(r'case[^\n]*HONK_ARCH_PACKAGES[^\n]*\bin\s*\n(.*?)\besac\b', text, re.S)
if not section:
    sys.exit("Cannot locate HONK_ARCH_PACKAGES mapping in build.sh")
targets = sorted(set(re.findall(r"\btarget\s*=\s*[\"']?([A-Za-z0-9_]+(?:-[A-Za-z0-9_.]+){2,})", section.group(1))))
if not targets:
    sys.exit("No Rust targets found in build.sh")
print("\n".join(targets))
PY_TARGETS
  )"
  mapfile -t targets <<< "$target_text"

  if ! command -v rustup >/dev/null 2>&1; then
    installer="$(mktemp)"
    curl --proto '=https' --tlsv1.2 -fLsS --retry 3 https://sh.rustup.rs -o "$installer"
    sh "$installer" -y --profile minimal --default-toolchain none --no-modify-path
    rm -f "$installer"
  fi

  stable="$(python3 - <<'PY_TOML' "$src/rust-toolchain.toml"
import sys, tomllib
print(tomllib.load(open(sys.argv[1], "rb"))["toolchain"]["channel"])
PY_TOML
  )"
  nightly="$(python3 - <<'PY_TOML' "$src/crates/honk-ebpf/rust-toolchain.toml"
import sys, tomllib
print(tomllib.load(open(sys.argv[1], "rb"))["toolchain"]["channel"])
PY_TOML
  )"

  rustup toolchain install "$stable" --profile minimal --component rustfmt,clippy
  rustup default "$stable"
  rustup target add --toolchain "$stable" "${targets[@]}"
  rustup toolchain install "$nightly" --profile minimal --component rust-src,llvm-tools

  source "$src/.github/ci/pins.env"
  archive="$(mktemp --suffix=.tar.zst)"
  curl -fLsS --retry 3 -o "$archive" \
    "https://github.com/aya-rs/bpf-linker/releases/download/v${BPF_LINKER_VERSION}/bpf-linker-x86_64-unknown-linux-musl.tar.zst"
  printf '%s  %s\n' "$BPF_LINKER_SHA256" "$archive" | sha256sum -c -
  mkdir -p "$CARGO_HOME/bin"
  tar --zstd -xf "$archive" -C "$CARGO_HOME/bin"
  rm -f "$archive"

  rustup target list --installed --toolchain "$stable"
)

# 同步到当前外层 Shell（同 step 继续跑 make 时生效）
export CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
export RUSTUP_HOME="${RUSTUP_HOME:-$HOME/.rustup}"
export PATH="$CARGO_HOME/bin:$PATH"

# 持久化到 GitHub Actions 后续 step
if [ -n "${GITHUB_ENV:-}" ]; then
  printf 'CARGO_HOME=%s\nRUSTUP_HOME=%s\n' "$CARGO_HOME" "$RUSTUP_HOME" >> "$GITHUB_ENV"
fi
if [ -n "${GITHUB_PATH:-}" ]; then
  printf '%s\n' "$CARGO_HOME/bin" >> "$GITHUB_PATH"
fi
## End of dae/honk
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
