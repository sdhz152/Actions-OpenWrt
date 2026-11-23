#!/bin/bash
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
# 8. 验证
go version
rustup --version
cargo --version
rustc --version
bpf-linker --version
rustup target list --installed --toolchain "$stable"
echo "安装完成"
