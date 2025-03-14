#!/bin/bash

# Function to install all required system dependencies
install_dependencies() {
    echo "Updating system and installing dependencies..."
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
        build-essential
}

install_zig() {
    echo "Installing system dependencies..."
    sudo apt-get update && sudo apt-get install -y build-essential cmake ninja-build python3 python3-pip git
    git clone git@github.com:ziglang/zig-bootstrap.git ~/.config/nvim/
    echo "System information:"
    echo "$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')-$(ldd --version | head -n 1 | awk '{print $1}' | tr '[:upper:]' '[:lower:]') $(lscpu | grep "Model name" | cut -d ':' -f 2 | xargs)"
    
    read -p "Enter the CPU architecture (e.g., icelake, skylake): " cpu_arch
    
    echo "Starting build process..."
   ~/.config/nvim/zig-bootstrap/build "$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')-$(ldd --version | head -n 1 | awk '{print $1}' | tr '[:upper:]' '[:lower:]')" "$cpu_arch"
}

# Function to clone and build Ghostty
build_ghostty() {
    echo "Building Ghostty..."
    git clone https://github.com/ghostty-org/ghostty
    (cd ghostty && zig build -p "$HOME/.local/bin" -Doptimize=ReleaseFast)
}

# Function to build Lua language server
build_lua_ls() {
    echo "Building Lua language server..."
    mkdir -p ~/.config/nvim
    (cd ~/.config/nvim && \
        git clone https://github.com/LuaLS/lua-language-server && \
        cd lua-language-server && \
        ./make.sh)
}

# Function to install Nerd Font
install_fonts() {
    echo "Installing fonts..."
    mkdir -p ~/.local/share/fonts
    (cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf)
}

# Function to clean Neovim directories
clean_neovim() {
    echo "Cleaning Neovim directories..."
    rm -rf ~/.local/share/nvim/
    rm -rf ~/.local/state/nvim/
}

# Function to install Neovim
install_neovim() {
    echo "Installing Neovim..."
    (cd ~/.config/nvim && \
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && \
        sudo rm -rf /opt/nvim && \
        sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz)
}

# Function to update bashrc
update_bashrc() {
    echo "Updating .bashrc..."
    mv ~/.config/nvim/.bashrc ~/.bashrc 2>/dev/null || true
    echo 'PATH=/opt/nvim-linux-x86_64/bin:/opt/nvim:~/.config/nvim/lua-language-server/bin/:$PATH' >> ~/.bashrc
}

# Main execution
main() {
    
    sudo apt install curl git -y

    install_zig &
    pid1=$!

    # Install dependencies first
    install_dependencies

    # Start asynchronous builds
    build_lua_ls &
    pid2=$!
    
    install_fonts &
    pid3=$!

    # Wait for background processes
    wait $pid2 $pid3

    # Sequential steps
    clean_neovim
    install_neovim
    
    wait $pid1
    build_ghostty

    # Final configuration
    update_bashrc

    echo "All tasks completed!"
}

# Run main function
main
