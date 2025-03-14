#!/bin/bash

install_dependencies() {
  sudo apt update -y
  sudo apt upgrade -y
  sudo apt install -y \
  curl \
  libgtk-4-dev \
  libadwaita-1-dev \
  git \
  blueprint-compiler \
  ninja-build \
  lua5.3 \
  perl \
  libdatetime-perl \
  libjson-perl \
  luarocks \
  ripgrep \
  build-essential \
  btop \
  cmake \
  python3 \
  python3-pip \
  jq
}

rust_update_or_install() {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

install_latest_nvim() {
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
}

install_ghostty() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
  cd ~/.config/ghostty/
  ghostty +show-config --default --docs
  rm ../ghostty/config -rf
  cp ~/.config/nvim/config ../ghostty/
}

clear_paths() {
  rm -rf ~/.local/share/nvim/
  rm -rf ~/.local/state/nvim/
  rm -rf ~/.config/nvim/lua-language-server
  sudo rm -rf /opt/nvim-linux-x86_64
}

move_config_files(){
  mv ~/.config/nvim/.bashrc ~/.bashrc
}

clear_and_clone_base() {
  clear_paths
  install_latest_nvim
  rust_update_or_install
  install_ghostty
  set_bashrc
}

set_bashrc() {
  mv ~/.config/nvim/bashrc ~/.bashrc
  mv ~/.config/nvim/config ~/.config/ghostty/config
}

main() {
  [ "$(pwd)" = "$HOME/.config/nvim" ] || { echo "Error: Current directory is not ~/.config/nvim"; exit 1; }
  install_dependencies
  clear_and_clone_base
}

main
