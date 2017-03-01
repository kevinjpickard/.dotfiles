# Linux Boostrapper
## Update and Upgrade ##
sudo apt-get update -y
sudo apt-get upgrade -y
#sudo apt dist-upgrade -y
sudo apt-get autoremove -y

## Repositories
#	Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
#	Spotify
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
#	Sublime
sudo add-apt-repository -y ppa:webupd8team/sublime-text-3
#	Veracrypt
sudo add-apt-repository -y ppa:unit193/encryption
# Kodi
sudo add-apt-repository -y ppa:team-xbmc/ppa
# Docker
curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -
apt-key fingerprint 58118E89F3A912897C070ADBF76221572C52609D
sudo add-apt-repository -y "deb https://apt.dockerproject.org/repo/ ubuntu-$(lsb_release -cs) main"

## Update New Repos
sudo apt-get update

## Apps
sudo curl https://raw.githubusercontent.com/kevinjpickard/.dotfiles/apt/.dotfiles/apps.conf -o ~/apps.conf 
sudo apt-get install -y $(grep -vE "^\s*#" apps.conf | tr "\n" " ")

## Powerline
#	Scratch directory
mkdir ~/Documents/github
mkdir ~/Documents/github/scratch
pip install --upgrade pip
sudo -H pip install powerline-status
#	Install powerline fonts
mkdir ~/scratch/fonts
sudo git clone https://github.com/powerline/fonts.git /home/kevin/Documents/github/scratch/fonts
sudo /home/kevin/Documents/github/scratch/fonts/install.sh

## Install oh-my-zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh

## ZSH Syntax Highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

## Install Keybase
curl -O https://prerelease.keybase.io/keybase_amd64.deb
sudo dpkg -i keybase_amd64.deb
sudo apt-get install -f
#run_keybase

## Clone github .dotfiles repo
echo "Pulling down system configuration files..."
rm ~/.bashrc ~/.bash_profile ~/.zshrc README.md ~/.vimrc
rm -rf ~/.dotfiles
git clone --bare https://github.com/kevinjpickard/.dotfiles.git $HOME/.dotfiles
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME fetch
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout apt
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME pull origin apt
echo ".dotfiles" >> .gitignore
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

## Monokai color scheme for Gnome Terminal
git clone git://github.com/pricco/gnome-terminal-colors-monokai.git $HOME/Documents/github/scratch
$HOME/Documents/github/scratch/gnome-terminal-colors-monokai/install.sh

## Install Vundle ##
echo "Installing Vundle..."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
#	Initialize and install plugins
echo "Initializing vim plugins..."
vim +PluginInstall +qall

## Install vagrant plugins
vagrant plugin install vagrant-saltdeps vagrant-scp vagrant-serverspec vagrant-share vagrant-vmware-fusion vagrant-winrm

## Settings
#   GNOME DE Extensions + Configs, if running
chmod +x ~/.dotfiles/gnome_settings.sh
~/.dotfiles/gnome_settings.sh
#		Start docker at boot
sudo systemctl enable docker
#		Manage docker sans sudo
sudo groupadd docker
sudo usermod -aG docker $USER

## Changing shells
chsh -s `which zsh`

## Changing origin
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME remote set-url origin git@github.com:kevinjpickard/.dotfiles.git

# Done
echo "Configuration finished! Please reboot, then run 'sudo sensors-detect'"
