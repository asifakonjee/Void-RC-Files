###################################################################
##       _        _  __      _    _                _             ##
##      / \   ___(_)/ _|    / \  | | _____  _ __  (_) ___  ___   ##
##     / _ \ / __| | |_    / _ \ | |/ / _ \| '_ \ | |/ _ \/ _ \  ##
##    / ___ \\__ \ |  _|  / ___ \|   < (_) | | | || |  __/  __/  ##
##   /_/   \_\___/_|_|   /_/   \_\_|\_\___/|_| |_|/ |\___|\___|  ##
##                                              |__/             ##
###################################################################
# This is my bashrc file.


export PATH=$PATH:/home/asif/.local/scripts

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

##------------------------ CHANGE TITLE OF TERMINALS -----------------------------##
case ${TERM} in
  alacritty|st|konsole*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
        ;;
  screen*)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
    ;;
esac

##--------------------------------------------- PROMPT -------------------------------------------##

function parse_git_dirty {
  STATUS="$(git status 2> /dev/null)"
  if [[ $? -ne 0 ]]; then printf ""; return; else printf " ["; fi
  if echo ${STATUS} | grep -c "renamed:"         &> /dev/null; then printf " >"; else printf ""; fi
  if echo ${STATUS} | grep -c "branch is ahead:" &> /dev/null; then printf " !"; else printf ""; fi
  if echo ${STATUS} | grep -c "new file::"       &> /dev/null; then printf " +"; else printf ""; fi
  if echo ${STATUS} | grep -c "Untracked files:" &> /dev/null; then printf " ?"; else printf ""; fi
  if echo ${STATUS} | grep -c "modified:"        &> /dev/null; then printf " *"; else printf ""; fi
  if echo ${STATUS} | grep -c "deleted:"         &> /dev/null; then printf " -"; else printf ""; fi
  printf " ]"
}

parse_git_branch() {
  # Long form
  git rev-parse --abbrev-ref HEAD 2> /dev/null
 # Short form
  # git rev-parse --abbrev-ref HEAD 2> /dev/null | sed -e 's/.*\/\(.*\)/\1/'
}

#PS1="\[\e[01;39m\]{ \[\e[01;32m\]\w \[\e[01;39m\]} \[\e[01;32m\]\[\$ \]\[\e[01;39m\] \[\e[1;37m\]"
PS1="\[\e[1;35m\]\$(parse_git_branch)\[\033[31m\]\$(parse_git_dirty)\]\n\[\e[01;39m\]{ \[\e[01;32m\]\w \[\e[01;39m\]} \[\e[01;39m\] \[\e[1;37m\]"
#PS1="\[\e[1;36m\]\$(parse_git_branch)\[\033[31m\]\$(parse_git_dirty)\[\033[00m\]\n\w\[\e[1;31m\] \[\e[1;36m\]\[\e[1;37m\] "
#PS1="\[\e[1;36m\]\$(parse_git_branch)\[\033[31m\]\$(parse_git_dirty)\n\[\033[1;33m\]  \[\e[1;37m\] \w \[\e[1;36m\]\[\e[1;37m\] "

###----------------- CD COMMAND ------------------------##

bettercd() {
    >/dev/null cd $1
    if [ -z $1 ]
    then
        while true;
        do
            selection="$(lsd -a | fzf --height 98% --reverse --info hidden --border rounded --prompt "$(pwd)/" --preview ' cd_pre="$(echo $(pwd)/$(echo {}))";
                    echo $cd_pre;
                    echo;
                    lsd -a --color=always "${cd_pre}";
                    bat --style=numbers --theme=ansi --color=always {} 2>/dev/null' --bind alt-down:preview-down,alt-up:preview-up --preview-window=right:65%)"
        if [[ -d "$selection" ]]
        then
            >/dev/null cd "$selection"
        elif [[ -f "$selection" ]]
        then
            for file in $selection;
            do
                if [[ $file == *.txt ]] || [[ $file == *.sh ]] || [[ $file == *.lua ]] || [[ $file == *.conf ]] || [[ $file == .*rc ]] || [[ $file == *rc ]] || [[ $file == autostart ]] || [[ $file == *.tex ]] || [[ $file == *.py ]]
                then
                    micro "$selection"
                elif [[ $file == *.docx ]] || [[ $file == *.odt ]]
                then
                    devour libreoffice "$selection" 2>/dev/null
                elif [[ $file == *.pdf ]]
                then
                    devour okular "$selection"
                elif [[ $file == *.jpg ]] || [[ $file == *.png ]] || [[ $file == *.xpm ]] || [[ $file == *.jpeg ]]
                then
                    devour gwenview "$selection"
                else [[ $file == *.xcf ]]
                    devour gimp "$selection"
            fi
        done
        else
            break
        fi
    done
    fi
}

alias bcd='bettercd'

##------------------- ALIAS -----------------------##
alias add='sudo xbps-install'
alias remove='sudo xbps-remove -R'
alias clean='sudo xbps-remove -o'
alias cc='sudo xbps-remove -O'
alias up='sudo xbps-install -Su'
alias restart='xcheckrestart'
alias search='xbps-query -Rs'
alias ls='exa -a -G --icons --color=always --group-directories-first' # my preferred listing
alias la='exa -al -G --icons --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l -G --icons --color=always --group-directories-first'  # long format
alias ..='cd ..'
alias pd='pwd'
alias gcl='git clone'
alias cat='bat --theme ansi'
alias rfm='ranger'
alias bconf='micro .bashrc'
alias zconf='micro .zshrc'
alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT0'
alias reboot='loginctl reboot'
alias poweroff='loginctl poweroff'

##------------------- SCRIPT ALIAS -----------------------##
alias cdi="fzfimg.sh --preview-window=right:75% --reverse --info hidden"
alias vsp='vsp.sh'
alias open='launch.sh'
##------------------- BASH HOME DECOR --------------------##

figlet KDE Plasma
neofetch
