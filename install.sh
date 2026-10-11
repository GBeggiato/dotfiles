# DOCS
# https://github.com/neovim/neovim/blob/master/BUILD.md
# https://github.com/neovim/neovim/blob/master/INSTALL.md#install-from-source

# prerequisites / other packages
echo "CONFIG_INSTALLER: adding more packages ..."
sudo xbps-install -RSuvdM \
    bash-completion       \
    neovim                \
    cmake                 \
    ctags                 \
    curl                  \
    gcc                   \
    gettext               \
    git                   \
    make                  \
    mupdf                 \
    nodejs                \
    python-tkinter        \
    tex                   \
    # scrot = screenshot
    scrot                 \
echo "CONFIG_INSTALLER: DONE"

# ----------------------------------------------------------------------------

# echo "NVIM_CONFIG_INSTALLER: START"
# # install location root path
# cd ~
# # install from source
# git clone https://github.com/neovim/neovim
# echo "NVIM_CONFIG_INSTALLER: repo cloned"
# cd neovim
# # most optimizations
# make CMAKE_BUILD_TYPE=Release
# sudo make install
# echo "NVIM_CONFIG_INSTALLER: neovim installed"
# # fetching personal init.lua
# mkdir ~/.config/nvim/ -p
# echo "NVIM_CONFIG_INSTALLER: ~/.config/nvim is there"
# cd ~/.config/nvim/
# wget https://raw.githubusercontent.com/GBeggiato/dotfiles/refs/heads/master/init.lua
# echo "NVIM_CONFIG_INSTALLER: downloaded latest commit of init.lua"
# sudo xbps-install -RSudMv npm
# echo "NVIM_CONFIG_INSTALLER: installed npm for the pyright server"
# echo "NVIM_CONFIG_INSTALLER: DONE"

# ----------------------------------------------------------------------------
# /usr/share/doc/steam

echo "INSTALLER STEAM: start"

# Install Steam
### Enable repositories
sudo xbps-install -RSuvdM      \
    void-repo-nonfree          \
    void-repo-multilib         \
    void-repo-multilib-nonfree \

### Install dependencies
sudo xbps-install -RSuvdM \
	steam                 \
	libgcc-32bit          \
	libstdc++-32bit       \
	libdrm-32bit          \
	libglvnd-32bit        \
	mono                  \
	mesa-32bit            \
	vulkan-loader         \
	mesa-dri-32bit        \
	gstreamer1            \
	amdvlk                \
	xf86-video-amdgpu     \
	mesa-vaapi            \
	mesa-vdpau            \
	mesa-dri-32bit        \

echo "INSTALLER STEAM: end"

