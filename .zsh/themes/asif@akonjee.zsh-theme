# zsh theme made by Dr. Asif Akonjee

if [[ "$USER" == "root" ]]; then
  PROMPT="%(?:%{$fg_bold[red]%}%{$fg_bold[yellow]%}%{$fg_bold[red]%} :%{$fg_bold[red]%} )"
  PROMPT+='%{$fg[cyan]%}  %c%{$reset_color%}'
  else
  PROMPT="%(?:%{$fg_bold[blue]%}{ %{$fg_bold[red]%}%~%{$fg_bold[blue]%}\${vcs_info_msg_0_} %{$fg_bold[blue]%}}"    #show the current directory only
  PROMPT+=' %{$fg_bold[green]%}%{$fg_bold[green]%} :%{$fg_bold[red]%} )'
  RPROMPT="%{$fg[blue]%}[ %{$fg[blue]%}%@ ]"
fi
