#!/usr/bin/env bash

## Power Managment
read -p "Do you wish to enable powermanagment? [y/n] " power_var
if [[ $power_var = y ]]
then
    pamac install tlp tlpui powertop
    currPWD=$PWD
    cd ./services/powertune
    ./init.sh
    cd $currPWD
fi
echo ""
##

## ZSH
read -p "Do you wish to switch to ZSH? [y/n] " change_to_bash_var
if [[ $change_to_bash_var = y ]]
then
    pamac install zsh zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting
    sudo chsh --shell=/bin/zsh $USER

    currentDir=$PWD
    # Init ohmyzsh
    cd $HOME
    rm -rf .oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    # Remove provided configs and themes
    rm .zshrc
    rm -rf .oh-my-zsh/custom

    ln -s $currentDir/zsh/.zshrc .zshrc
    cd .oh-my-zsh
    ln -s $currentDir/zsh/custom custom
    cd custom/plugins
    ln -s /usr/share/zsh/plugins/* .

    cd $currentDir/

    # Set password feedback
    read -p "Copy this 'Defaults pwfeedback', paste it to the top of the file. Understood? [y/n] " visudo_var
    if [[ $visudo_var = y ]] ; then
        sudo visudo
    fi
    source ~/.zshrc
fi
echo ""
##

## Applications
read -p "Do you wish to install all apps? [y/n] " install_app_var
if [[ $install_app_var = y ]]
then
    pamac install github-desktop-bin visual-studio-code-bin google-chrome android-studio nautilus-copy-path android-messages-desktop-bin dotnet-sdk neovim jq dart mailspring

    sudo pacman -Syy --needed discord auto-cpufreq jdk-openjdk jdk11-openjdk jdk8-openjdk jre-openjdk jre-openjdk-headless jre11-openjdk jre11-openjdk-headless jre8-openjdk jre8-openjdk-headless nodejs npm bash-completion

    sudo flatpak install Spotify

    sudo snap install flutter --classic

    pip install jedi

    read -p "Do you wish to install all apps? [y/n] " install_app_var
    if [[ $install_app_var = y ]]; then
        echo ""
    fi
    systemctl start auto-cpufreq
    systemctl enable auto-cpufreq
fi
echo ""
##

## Neovim
read -p "Do you wish to link vim config files? [y/n] " vim_var
if [[ $vim_var = y ]]; then
    pamac install ccls texlive-bibtexextra texlive-gantt texlive-pictures
    sudo pacman -Syu texlive-core texlive-fontsextra texlive-latexextra texlive-science biber
    pip install cpplint

    # Install digestif for latex
    wget -P ~/.local/bin https://raw.githubusercontent.com/astoff/digestif/master/scripts/digestifi
    chmod +x ~/.local/bin/digestif

    currentDir=$PWD
    cd ~/.config/
    rm -rf nvim

    ln -s $currentDir/nvim nvim
    cd $currentDir/..

    sh -c 'curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    nvim -es -u ~/.config/nvim/init.vim -i NONE -c "PlugInstall" -c "qa"
fi
echo ""
##

## Shell Theme
read -p  "Do you wish to install Firefox Gnome theme? [y/n] " install_theme_var
if [[ $install_theme_var = y ]]
then
    curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash
fi
echo ""
##

printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
echo ""
echo "Done! 😊"
