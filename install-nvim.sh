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
    build-essential \
    btop \
    cmake \
    python3 \
    python3-pip \
    jq \
}

rust_update_or_install() {
    # Check if rustup is installed
    if command -v rustup &> /dev/null; then
        echo "Rust is already installed. Updating Rust..."
        rustup update
    else
        echo "Rust is not installed. Installing Rust..."
        # Install Rust using rustup
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        # Source the cargo environment to update the current shell session
        source "$HOME/.cargo/env"
        echo "Rust has been installed successfully."
    fi
}

install_latest_zig() {
    # Check for required dependencies
    if ! command -v curl &> /dev/null; then
        echo "Error: curl is required but not installed."
        return 1
    fi
    if ! command -v jq &> /dev/null; then
        echo "Error: jq is required but not installed. Install with 'sudo apt-get install jq' or similar."
        return 1
    fi

    # Get download index JSON
    local json_url="https://ziglang.org/download/index.json"
    local json_data=$(curl -s "$json_url")

    # Find latest version (entry with most recent date)
    local latest_key=$(echo "$json_data" | jq -r 'to_entries | max_by(.value.date) | .key')

    # Get download details for x86_64-linux
    local tarball_url=$(echo "$json_data" | jq -r ".\"$latest_key\".\"x86_64-linux\".tarball")
    local expected_sha=$(echo "$json_data" | jq -r ".\"$latest_key\".\"x86_64-linux\".shasum")

    # Validate URL
    if [[ "$tarball_url" == "null" || -z "$tarball_url" ]]; then
        echo "Error: Could not find download URL for x86_64-linux"
        return 1
    fi

    # Create temporary directory
    local tmp_dir=$(mktemp -d)
    echo "Created temporary directory: $tmp_dir"

    # Download the tarball
    local tarball_path="$tmp_dir/$(basename "$tarball_url")"
    echo "Downloading Zig..."
    if ! curl -# -o "$tarball_path" "$tarball_url"; then
        echo "Failed to download Zig"
        rm -rf "$tmp_dir"
        return 1
    fi

    # Verify checksum
    echo "Verifying checksum..."
    local actual_sha=$(sha256sum "$tarball_path" | awk '{print $1}')
    if [[ "$expected_sha" != "$actual_sha" ]]; then
        echo "Checksum verification failed!"
        echo "Expected: $expected_sha"
        echo "Received: $actual_sha"
        rm -rf "$tmp_dir"
        return 1
    fi

    # Extract the tarball
    echo "Extracting files..."
    if ! tar xf "$tarball_path" -C "$tmp_dir"; then
        echo "Failed to extract archive"
        rm -rf "$tmp_dir"
        return 1
    fi

    # Get extracted directory (assumes only one directory in temp dir)
    local extracted_dir=$(find "$tmp_dir" -mindepth 1 -maxdepth 1 -type d)

    # Install to /usr/local/zig
    echo "Installing Zig system-wide (requires sudo)"
    sudo rm -rf /usr/local/zig 2> /dev/null  # Remove previous installation
    sudo mv "$extracted_dir" /usr/local/zig

    # Create symlink to binary
    sudo ln -sf /usr/local/zig/zig /usr/local/bin/zig

    # Cleanup
    rm -rf "$tmp_dir"

    echo "Successfully installed Zig $(/usr/local/bin/zig version)"
    echo "Zig binary located at: /usr/local/bin/zig"
}
install_latest_nvim() {
    # Check for required dependencies
    if ! command -v curl &> /dev/null; then
        echo "Error: curl is required but not installed."
        return 1
    fi

    # Define URLs
    local tarball_url="https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz"
    local checksum_url="https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz.sha256sum"

    # Create temporary directory
    local tmp_dir=$(mktemp -d)
    echo "Created temporary directory: $tmp_dir"

    # Download paths
    local tarball_path="$tmp_dir/nvim-linux-x86_64.tar.gz"
    local checksum_path="$tarball_path.sha256sum"

    # Download Neovim
    echo "Downloading Neovim..."
    if ! curl -# -o "$tarball_path" "$tarball_url"; then
        echo "Failed to download Neovim tarball"
        rm -rf "$tmp_dir"
        return 1
    fi

    # Download checksum file
    echo "Downloading checksum..."
    if ! curl -# -o "$checksum_path" "$checksum_url"; then
        echo "Failed to download checksum file"
        rm -rf "$tmp_dir"
        return 1
    fi

    # Extract expected checksum
    local expected_sha=$(cut -d ' ' -f 1 "$checksum_path")
    if [ -z "$expected_sha" ]; then
        echo "Failed to extract expected checksum"
        rm -rf "$tmp_dir"
        return 1
    fi

    # Verify checksum
    echo "Verifying checksum..."
    local actual_sha=$(sha256sum "$tarball_path" | awk '{print $1}')
    if [[ "$expected_sha" != "$actual_sha" ]]; then
        echo "Checksum verification failed!"
        echo "Expected: $expected_sha"
        echo "Received: $actual_sha"
        rm -rf "$tmp_dir"
        return 1
    fi

    # Extract the tarball
    echo "Extracting files..."
    if ! tar xf "$tarball_path" -C "$tmp_dir"; then
        echo "Failed to extract archive"
        rm -rf "$tmp_dir"
        return 1
    fi

    # Get extracted directory
    local extracted_dir=$(find "$tmp_dir" -mindepth 1 -maxdepth 1 -type d -name "nvim-linux-x86_64" -print -quit)
    if [ -z "$extracted_dir" ]; then
        echo "Failed to find extracted Neovim directory"
        rm -rf "$tmp_dir"
        return 1
    fi

    # Install to /usr/local/nvim
    echo "Installing Neovim system-wide (requires sudo)"
    sudo rm -rf /usr/local/nvim 2> /dev/null  # Remove previous installation
    sudo mv "$extracted_dir" /usr/local/nvim

    # Create symlink to binary
    sudo ln -sf /usr/local/nvim/bin/nvim /usr/local/bin/nvim

    # Cleanup
    rm -rf "$tmp_dir"

    # Verify installation
    echo "Successfully installed Neovim $(/usr/local/bin/nvim --version | head -n 1 | awk '{print $2}')"
    echo "Neovim binary located at: /usr/local/bin/nvim"
}

install_ghostty() {
    local repo_dir="${HOME}/.local/src/ghostty"
    local install_dir="${HOME}/.local"

    # Create directory structure if it doesn't exist
    mkdir -p "${repo_dir%/*}" "${install_dir}"

    # Clone or update repository
    if [[ -d "$repo_dir" ]]; then
        echo "Updating existing Ghostty repository..."
        (cd "$repo_dir" && git pull)
    else
        echo "Cloning Ghostty repository..."
        git clone https://github.com/ghostty-org/ghostty "$repo_dir"
    fi || { echo "Error with repository operations"; return 1; }

    # Build and install
    echo "Building Ghostty..."
    (cd "$repo_dir" && zig build -p "$install_dir" -Doptimize=ReleaseFast) || {
        echo "Build failed"; return 1
    }

    # Configure as default terminal
    local ghostty_bin="${install_dir}/bin/ghostty"
    if [[ -x "$ghostty_bin" ]]; then
        echo "Setting Ghostty as default terminal emulator..."
        sudo update-alternatives --install /usr/bin/x-terminal-emulator \
            x-terminal-emulator "$ghostty_bin" 100 && \
        sudo update-alternatives --set x-terminal-emulator "$ghostty_bin"
    else
        echo "Error: Ghostty binary not found at ${ghostty_bin}"
        return 1
    fi

    echo "Ghostty installed successfully!"
}
clear_paths() {
    echo "Clearing all paths that will be written to..."
    
    # Clear Neovim directories
    rm -rf ~/.local/share/nvim/
    rm -rf ~/.local/state/nvim/
    
    # Clear Zig bootstrap directory
    rm -rf ~/.config/nvim/zig-bootstrap
    
    # Clear Ghostty directory
    rm -rf ~/ghostty
    
    # Clear Lua language server directory
    rm -rf ~/.config/nvim/lua-language-server
    
    # Clear fonts directory
    rm -rf ~/.local/share/fonts/DroidSansMNerdFont-Regular.otf
    
    # Clear Neovim installation
    sudo rm -rf /opt/nvim
    sudo rm -rf /opt/nvim-linux-x86_64
    
    # Clear .bashrc modifications
    sed -i '/\/opt\/nvim-linux-x86_64\/bin/d' ~/.bashrc
    sed -i '/\/opt\/nvim/d' ~/.bashrc
    sed -i '/~\/.config\/nvim\/lua-language-server\/bin/d' ~/.bashrc
}

clear_and_clone_base() {
    clear_paths
    install_latest_zig
    install_latest_nvim
    rust_update_or_install
    install_ghostty
  }

main() {
  install_dependencies
  clear_and_clone_base
}

main
