# DOCS
# https://github.com/neovim/neovim/blob/master/BUILD.md
# https://github.com/neovim/neovim/blob/master/INSTALL.md#install-from-source

# install location root path
cd ~
# prerequisites
sudo apt-get install gettext cmake curl build-essential git # ninja-build 
# install from source
git clone https://github.com/neovim/neovim
cd neovim

# most optimizations
make CMAKE_BUILD_TYPE=Release
sudo make install
echo "LOCAL: neovim installed"

# fetching personal init.lua
mkdir ~/.config/nvim/ -p
echo "LOCAL: ~/config/nvim is there"
wget https://raw.githubusercontent.com/GBeggiato/dotfiles/refs/heads/master/init.lua
echo "LOCAL: downloaded latest commit of init.lua"

echo "LOCAL: DONE"
