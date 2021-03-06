HISTFILE=~/.cache/zshhistory
HISTSIZE=10000
SAVEHIST=10000

function git_branch_name()
{
  branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
  if [[ $branch == "" ]];
  then
    :
  else
    echo '@ '$branch' '
  fi
}

setopt appendhistory
setopt prompt_subst

bindkey '^[[H'		beginning-of-line
bindkey '^[[1~'		beginning-of-line
bindkey '^[[F'		end-of-line
bindkey '^[[4~'		end-of-line
bindkey '^[[3~'		delete-char
bindkey '^[[1;5D'	vi-backward-word
bindkey '^[[1;5C'	vi-forward-blank-word-end
bindkey '^[[5~'		beginning-of-history
bindkey '^[[6~'		end-of-history
bindkey '^ '		autosuggest-accept
bindkey '^H'		vi-backward-kill-word

bindkey -r '^W'

autoload -U colors && colors
prompt='%{$fg[cyan]%}%1~ %{$fg[magenta]%}$(git_branch_name)%{%(#~$fg[blue]~$fg[yellow])%}%#%{$fg[default]%} '

EDITOR=vim

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

[ -f "$HOME/zsh/aliasrc" ] && source "$HOME/zsh/aliasrc"

export PATH="~/.dotnet/tools:$PATH"

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
