#!/bin/sh

function error {
	printf " *** Error:\n *** $@\n"
	exit 1
}

function print_header {
	[ $# -ge 1 ] || error "print_header: At least one argument required"

	printf "\n===============================================\n"
	echo " $@"
	echo "==============================================="
}

function do_backup() {
	[ $# -eq 1 ] || error "do_backup: Wrong number of arguments"

	local target=$1
	echo "Creating backup of $target in -> $target.bak"
	rm -rf $target.bak
	mv $target $target.bak || error "do_backup: Could not create backup"
}

function detect_distro() {
	[ $# -eq 4 ] || error "detect_distro: Wrong number of args"

	# Archlinux packages
	local arch_pkg_list="ack ag curl devhelp dmenu dunst feh firefox git \
		gvim i3 networkmanager network-manager-applet numlockx \
		pavucontrol playerctl powertop the_silver_searcher tig tmux \
		ttf-font-awesome wget xautolock xorg-xrandr xorg-setxkbmap \
		xorg-xbacklight xsel zsh"
	local arch_unofficial_pkgs="megasync skypeforlinux-stable-bin spotify \
		ttf-iosevka-term"

	_pkg_mgr_var=$1
	_pkg_mgr_inst_var=$2
	_pkg_list_var=$3
	_unofficial_pkgs=$4

	command -v pacman 2>&1 >/dev/null && {
		eval $_pkg_mgr_var=pacman
		eval $_pkg_mgr_inst_var=\"-S --noconfirm --needed\"
		eval $_pkg_list_var="\$arch_pkg_list"
		eval $_unofficial_pkgs="\$arch_unofficial_pkgs"
		echo "Distribution detected: Archlinux"
		return 0
	}

	return 1
}

function install_pkg() {
	[ $# -eq 3 ] || error "install_pkg: Wrong number of arguments"

	local _pkg_mgr=$1
	local _pkg_mgr_install="$2"
	local _pkg_list="$3"

	command -v sudo 2>&1 >/dev/null || {
		echo "Installing sudo"
		su -c "$_pkg_mgr $_pkg_install sudo"
		su -c "/usr/sbin/usermod -a -G sudo $USER"
		echo "Sudo installed. Please log out and log in again, and restart the script"
		exit 0
	}

	echo "Installing the following packages:"
	printf "\n\t"
	echo $_pkg_list
	eval sudo $_pkg_mgr $_pkg_mgr_install $_pkg_list
	}

function install_src() {
	[ -d $HOME/.oh-my-zsh ] || {
		echo "Installing ohmyzsh"
		curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh >$TMP_DIR/zsh-installer.sh &&
			sh $TMP_DIR/zsh-installer.sh
	}

	command -v st 2>&1 >/dev/null || {
		local src_dir=$HOME/src
		local st_version=0.8.1
		local st_src=$src_dir/st-$st_version
		local st_tar=$src_dir/st-$st_version.tar.gz

		[ -e $st_tar ] && do_backup $st_tar
		[ -d $st_src ] && do_backup $st_src

		echo "Installing st"
		echo " * Checking out source code"
		mkdir -p $src_dir
		wget -q -P $src_dir https://dl.suckless.org/st/st-$st_version.tar.gz
		echo " * Uncompressing the source code"
		tar -xvf $st_tar -C $src_dir
		rm -f $st_tar
		echo " * Downloading and applying patches:"
		echo "    - No bold colors"
		wget -q -O $st_src/no-bold-colors.diff https://st.suckless.org/patches/solarized/st-no_bold_colors-$st_version.diff
		patch -s -d $st_src -i $st_src/no-bold-colors.diff
		echo "    - Solarized"
		wget -q -O $st_src/solarized.diff https://st.suckless.org/patches/solarized/st-solarized-both-$st_version.diff
		patch -s -d $st_src -i $st_src/solarized.diff
		echo " * Compiling the source code"
		make -s -C $st_src
		echo " * Installing st"
		sudo make -s -C $st_src install
	}
}

function set_configuration() {
	local dotfiles=$HOME/dotfiles

	[ -d $dotfiles ] || {
		echo "Downloading configuration repository"
		git clone "https://github.com/sgtio/dotfiles.git" $dotfiles
	}

	echo " * Setting up ZSH"
	[ -e $HOME/.zshrc ] && do_backup $HOME/.zshrc
	[ -e $HOME/.aliases ] && do_backup $HOME/.aliases
	[ -e $HOME/.environment ] && do_backup $HOME/.environment
	[ -d $HOME/.dircolors ] && do_backup $HOME/.dircolors
	cat $dotfiles/zsh/zshrc $HOME/.zshrc.bak > $HOME/.zshrc
	ln -s $dotfiles/zsh/aliases $HOME/.aliases
	ln -s $dotfiles/zsh/environment $HOME/.environment
	mkdir -p $HOME/.dircolors
	curl -fsSL https://raw.githubusercontent.com/arcticicestudio/nord-dircolors/develop/src/dir_colors >$HOME/.dircolors/dircolors.nord

	echo " * Setting up vim"
	[ -e $HOME/.vimrc ] && do_backup $HOME/.vimrc
	[ -d $HOME/.vim_runtime ] && do_backup $HOME/.vim_runtime
	ln -s $dotfiles/vim/vimrc $HOME/.vimrc
	ln -s $dotfiles/vim/vim_runtime $HOME/.vim_runtime
	mkdir -p $HOME/.vim_runtime/bundle
	curl -fsSL https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh >$TMP_DIR/dein-installer.sh &&
		sh $TMP_DIR/dein-installer.sh $HOME/.vim_runtime/bundle

	echo " * Setting up tmux"
	[ -e $HOME/.tmux.conf ] && do_backup $HOME/.tmux.conf
	[ -d $HOME/.tmux] && do_backup $HOME/.tmux
	ln -s $dotfiles/tmux/tmux.conf $HOME/.tmux.conf
	mkdir -p $HOME/.tmux/themes
	git clone "https://github.com/arcticicestudio/nord-tmux" ~/.tmux/themes/nord-tmux

	echo " * Setting up tig"
	[ -e $HOME/.tigrc ] && do_backup $HOME/.tigrc
	ln -s $dotfiles/tig/tigrc $HOME/.tigrc

	echo " * Setting up X11"
	[ -e $HOME/.Xmodmap ] && do_backup $HOME/.Xmodmap
	[ -e $HOME/.Xprofile ] && do_backup $HOME/.Xprofile
	[ -e $HOME/.Xresources ] && do_backup $HOME/.Xresources
	[ -d $HOME/.Xresources.d ] && do_backup $HOME/.Xresources.d
	ln -s $dotfiles/X11/Xmodmap $HOME/.Xmodmap
	ln -s $dotfiles/X11/Xprofile $HOME/.Xprofile
	ln -s $dotfiles/X11/Xresources $HOME/.Xresources
	mkdir -p $dotfiles/X11/Xresources.d $HOME/.Xresources.d
	curl -fsSL "https://raw.githubusercontent.com/arcticicestudio/nord-xresources/develop/src/nord" >$HOME/.Xresources.d/Xresources-nord

	echo " * Setting up ctags"
	[ -e $HOME/.ctagsrc ] && do_backup $HOME/.ctagsrc
	ln -s $dotfiles/ctags/ctagsrc $HOME/.ctagsrc

	echo " * Setting up dunst"
	[ -e $HOME/.dunstrc ] && do_backup $HOME/.dunstrc
	ln -s $dotfiles/dunst/dunstrc $HOME/.dunstrc

	echo " * Setting up i3"
	[ -d $HOME/.config/i3 ] && do_backup $HOME/.config/i3
	mkdir -p $HOME/.config
	ln -s $dotfiles/i3 $HOME/.config/i3

	echo " * Setting up scripts"
	[ -d $HOME/.config/scripts ] && do_backup $HOME/.config/scripts
	ln -s $dotfiles/scripts $HOME/.config/scripts
	mkdir -p $HOME/tmp/xscreensaver

	echo " * Setting up git"
	git config --global user.name $USERNAME
	git config --global user.email $EMAIL
	git config --global alias.br branch
	git config --global alias.co checkout
	git config --global alias.ci commit
	git config --global alias.st status

	echo " * Setting up mutt"
	[ -e $HOME/.muttrc ] && do_backup $HOME/.muttrc
	[ -d $HOME/.mutt ] && do_backup $HOME/.mutt
	ln -s $dotfiles/mutt/muttrc $HOME/.muttrc
	mkdir -p $HOME/.mutt
	cp $dotfiles/mutt/* $HOME/.mutt

}

function deploy() {
	echo "Deploying new installation..."
	#echo "You will be prompted to install different configurations"
	#echo "Alternatively, run this script with -a or --all to get everything
	#echo "installed"

	print_header "Determining distribution (only Archlinux supported so far)"
	local pkg_mgr=""
	local pkg_mgr_install=""
	local pkg_list=""
	detect_distro pkg_mgr pkg_mgr_install pkg_list unofficial_pkgs

	print_header "Installing dependencies through $pkg_mgr"
	install_pkg $pkg_mgr "$pkg_mgr_install" "$pkg_list"

	print_header "Installing dependencies from source"
	install_src

	print_header "Setting up configuration"
	set_configuration

	print_header "Done"
	echo "Setup finished succesfully"
	echo "You might want to install the following packages from unofficial repositories:"
	printf "\n\t $unofficial_pkgs\n"
}

TMP_DIR=/tmp
USERNAME=sgtio
EMAIL=sejoruiz@gmail.com
deploy
