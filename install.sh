#!/bin/bash
. ./ask.sh
# set -x
# exit when any command fails
set -e
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

ask_to_install_on_debian() {
    if ! command -v $1; then
        if ask "Is your system a debian based OS AND is your user part of the sudo group AND you want to install $1" Y; then
            sudo apt install $1
        else
            echo "Please ask your administrator to install $1 before rerunning this script."
            exit 1
        fi
    fi
}

echo "===- Verify and install requirements -==="
ask_to_install_on_debian curl
ask_to_install_on_debian git
ask_to_install_on_debian fd-find

echo "===- ZSH installation -==="
if ask "Is your system a debian based OS AND is your user part of the sudo group?" Y; then
    sudo apt install zsh
else
    INSTALL_PATH="$HOME/.zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh-bin/master/install)"
    LINE="export PATH=$PATH:$INSTALL_PATH"
    FILE="$HOME/.profile"
    if test -f "$FILE"; then
        grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
    else
        echo "$LINE" > "$FILE"
    fi
    . $FILE
fi

# In case zsh is installed as non-root, you will need to export this path
export PATH="$HOME/.local/bin:$PATH"

echo "===- Oh My Zsh installation -==="
if ask "Do you want to install Oh My Zsh ?" Y; then
    curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash -s -- RUNZSH=no

    if ask "Do you want to install PowerLevel10k theme ?" Y; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    fi

    if ask "Do you want to install Oh My Zsh plugins ?" Y; then
        cd ~/.oh-my-zsh/custom/plugins/
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
        git clone https://github.com/changyuheng/zsh-interactive-cd.git
        git clone https://github.com/zdharma-continuum/history-search-multi-word.git
        git clone https://github.com/zsh-users/zsh-autosuggestions.git
        git clone https://github.com/changyuheng/fz.git
        git clone https://github.com/Aloxaf/fzf-tab.git
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git
    fi
fi

echo "===- Tmux Plugins installation -==="
if ask "Do you want to install Tmux plugins and conf ?" Y; then
    ask_to_install_on_debian tmux
    git clone https://github.com/egel/tmux-gruvbox.git ~/.tmux/plugins/tmux-gruvbox

    if ask "Do you want to override your ~/.tmux.conf with the one preconfigured in this repo?" Y; then
        cp "$SCRIPT_DIR"/.tmux.conf ~/.tmux.conf
    fi
fi

echo "===- FZF installation -==="
if ask "Do you want to install Fuzzy File System (aka fzf) ?" Y; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi

echo "===- Update zshrc -==="
if ask "Do you want to override your .zshrc with the one preconfigured in this repo?" Y; then
    cp "$SCRIPT_DIR/zshrc" ~/.zshrc
fi

echo "===- LET'S GOOOOOO -==="
zsh
