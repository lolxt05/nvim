#!/bin/bash

# Function to install all required system dependencies
install_dependencies() {
    echo "Updating system and installing dependencies..."
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install -y \
        libgtk-4-dev \
        libadwaita-1-dev \
        git \
        blueprint-compiler \
        zig \
        ninja-build \
        lua \
        perl \
        libdatetime-perl \
        libjson-perl \
        luarocks \
        ripgrep \
        build-essential
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
    # Install dependencies first
    install_dependencies

    # Start asynchronous builds
    build_ghostty &
    pid1=$!
    
    build_lua_ls &
    pid2=$!
    
    install_fonts &
    pid3=$!

    # Wait for background processes
    wait $pid1 $pid2 $pid3

    # Sequential steps
    clean_neovim
    install_neovim

    # Final configuration
    update_bashrc

    echo "All tasks completed!"
}

# Run main function
main
