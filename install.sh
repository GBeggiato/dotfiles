# DOCS
# https://github.com/neovim/neovim/blob/master/BUILD.md
# https://github.com/neovim/neovim/blob/master/INSTALL.md#install-from-source
echo "NVIM_CONFIG_INSTALLER: START"

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
echo "NVIM_CONFIG_INSTALLER: neovim installed"

# fetching personal init.lua
mkdir ~/.config/nvim/ -p
echo "NVIM_CONFIG_INSTALLER: ~/.config/nvim is there"

cd ~/.config/nvim/
wget https://raw.githubusercontent.com/GBeggiato/dotfiles/refs/heads/master/init.lua
echo "NVIM_CONFIG_INSTALLER: downloaded latest commit of init.lua"

sudo apt install npm
echo "NVIM_CONFIG_INSTALLER: installed npm for the pyright server"

echo "NVIM_CONFIG_INSTALLER: DONE"
