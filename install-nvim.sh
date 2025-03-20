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
  jq \
  fd-find \
  sshpass \
  btop
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
  cp ~/.config/nvim/config ~/.config/ghostty/
}

clear_paths() {
  rm -rf ~/.local/share/nvim/
  rm -rf ~/.local/state/nvim/
  rm -rf ~/.config/nvim/lua-language-server
  sudo rm -rf /opt/nvim-linux-x86_64
}

clear_and_clone_base() {
  clear_paths
  install_latest_nvim
  rust_update_or_install
  install_ghostty
  set_bashrc
}

set_configs() {
  /bin/cp -rf ~/.config/nvim/bashrc ~/.bashrc
  /bin/cp -rf ~/.config/nvim/config ~/.config/ghostty/config
  /bin/cp -rf ~/.config/nvim/bashrc_custom ~/.custom_bashrc
  rm -rf ~/.config/btop/*
  /bin/cp -rf ~/.config/nvim/btop ~/.config/btop
  source ~/.bashrc
}

main() {
  [ "$(pwd)" = "$HOME/.config/nvim" ] || { echo "Error: Current directory is not ~/.config/nvim"; exit 1; }
  install_dependencies
  read -p "Clear nvim and ghostty install: (Y/N)" clear_install
  read -p "install rust (Y/N)" install_rust
  read -p "install ghostty (required for ghostty install)(Y/N)" install_ghostty_var
  read -p "install nvim (required for ghostty install)(Y/N)" install_nvim
  read -p "set bashrc and ghostty config (Y/N)" overwrite_configs
  if [[ clear_install == [yY] ]]; then
    clear_paths
  fi
  if [[ install_rust == [yY] ]]; then
    rust_update_or_install
  fi
  if [[ install_ghostty_var == [yY] ]]; then
    install_ghostty
  fi
  if [[ install_nvim == [yY] ]]; then
    install_latest_nvim
  fi
  if [[ overwrite_configs ]]; then
    set_configs
  fi 
}

main
