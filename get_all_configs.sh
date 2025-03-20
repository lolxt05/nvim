rm -f ~/.config/nvim/bashrc
rm -f ~/.config/nvim/ghostty_config
rm -f ~/.config/nvim/ghostty_theme
rm -f ~/.config/nvim/bashrc_custom
rm -rf ~/.config/nvim/btop
cp ~/.bashrc ~/.config/nvim/bashrc
cp ~/.custom_bashrc ~/.config/nvim/bashrc_custom
cp ~/.config/ghostty/config ~/.config/nvim/ghostty_config
cp ~/ghostty/zig-out/share/ghostty/themes/custom ~/.config/nvim/ghostty_theme
cp -r ~/.config/btop ~/.config/nvim/btop
