# DOCS
# https://github.com/neovim/neovim/blob/master/BUILD.md
# https://github.com/neovim/neovim/blob/master/INSTALL.md#install-from-source

# prerequisites / other packages
echo "CONFIG_INSTALLER: adding more packages ..."
sudo xbps-install -SudMv bash-completion cmake ctags curl gcc gettext git make mupdf nodejs python-tkinter tex
echo "CONFIG_INSTALLER: DONE"

# ----------------------------------------------------------------------------

echo "NVIM_CONFIG_INSTALLER: START"
# install location root path
cd ~
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
# sudo xbps-install -SudMv npm
echo "NVIM_CONFIG_INSTALLER: installed npm for the pyright server"
echo "NVIM_CONFIG_INSTALLER: DONE"

# ----------------------------------------------------------------------------

echo "BASHRC_CONFIG_INSTALLER: start"

echo "# .bashrc" > ~/.bashrc
echo "" >> ~/.bashrc
echo "# If not running interactively, don't do anything" >> ~/.bashrc
echo "[[ $- != *i* ]] && return" >> ~/.bashrc
echo "" >> ~/.bashrc
echo "alias ls='ls --color=auto'" >> ~/.bashrc
echo "PS1='[\u@\h] \w\n\$ '" >> ~/.bashrc
echo "" >> ~/.bashrc
echo "### added from mint bashrc" >> ~/.bashrc
echo "# don't put duplicate lines or lines starting with space in the history." >> ~/.bashrc
echo "# See bash(1) for more options" >> ~/.bashrc
echo "HISTCONTROL=ignoreboth" >> ~/.bashrc
echo "# append to the history file, don't overwrite it" >> ~/.bashrc
echo "shopt -s histappend" >> ~/.bashrc
echo "# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)" >> ~/.bashrc
echo "HISTSIZE=100" >> ~/.bashrc
echo "HISTFILESIZE=200" >> ~/.bashrc
echo "# check the window size after each command and, if necessary," >> ~/.bashrc
echo "# update the values of LINES and COLUMNS." >> ~/.bashrc
echo "shopt -s checkwinsize" >> ~/.bashrc
echo "" >> ~/.bashrc
echo "# some more ls aliases" >> ~/.bashrc
echo "alias la='ls -ahl'" >> ~/.bashrc
echo "alias grep='grep --color=auto'" >> ~/.bashrc
echo "" >> ~/.bashrc
echo "alias update='echo "---------------------" && echo "sudo xbps-install -Suv" && sudo xbps-install -Suv'" >> ~/.bashrc

echo "BASHRC_CONFIG_INSTALLER: DONE"
