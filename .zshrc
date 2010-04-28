# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory extendedglob nomatch notify prompt_subst
unsetopt autocd beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/hyatt/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias ls='ls --color=auto'
alias sbroot="sbroot -m -w linux32"
alias baulkD='cd /home/hyatt/Source/qt4/baulk/src'
alias amdroid='cd /home/hyatt/Source/android/amdroid-h'

export CVSROOT=:pserver:jacoba@cvs/cvs
export EDITOR=vim
PATH=$PATH:/usr/local/bin:/opt/kde/bin:/opt/android-sdk/tools:/opt/java/bin:/usr/share/java/apache-ant/bin

bindkey '^R' history-incremental-search-backward
bindkey '\e[3~' delete-char
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
bindkey '\e[2~' overwrite-mode
bindkey '^i' expand-or-complete-prefix


###### Prompt ######
function precmd {
    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} - 1 ))

    ###
    # Truncate the path if it's too long.
    
    PR_FILLBAR=""
    PR_PWDLEN=$TERMWIDTH
    
    local promptsize=${#${(%):---(%n@%m:%l)---()--}}
    local pwdsize=${#${(%):-%~}}
    
    (( PR_PWDLEN = $TERMWIDTH / 2 - $TERMWIDTH / 4 ))
}


setopt extended_glob
preexec () {
    if [[ "$TERM" == "screen" ]]; then
	local CMD=${1[(wr)^(*=*|sudo|-*)]}
	echo -n "\ek$CMD\e\\"
    fi
}


setprompt () {
    ###
    # Need this so the prompt will work.

    setopt prompt_subst


    ###
    # See if we can use colors.

    autoload colors zsh/terminfo
    if [[ "$terminfo[colors]" -ge 8 ]]; then
	colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
	(( count = $count + 1 ))
    done
    PR_NO_COLOUR="%{$terminfo[sgr0]%}"


    ###
    # See if we can use extended characters to look nicer.
    
    typeset -A altchar
    set -A altchar ${(s..)terminfo[acsc]}
    PR_SET_CHARSET="%{$terminfo[enacs]%}"
    PR_SHIFT_IN="%{$terminfo[smacs]%}"
    PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
    PR_HBAR=${altchar[q]:--}
    PR_ULCORNER=${altchar[l]:--}
    PR_LLCORNER=${altchar[m]:--}
    PR_LRCORNER=${altchar[j]:--}
    PR_URCORNER=${altchar[k]:--}

    ###
    # Chroot info.

    ###
    # Git prompt
    git_prompt_info() {
	ref=$(git symbolic-ref HEAD 2> /dev/null) || return
	echo "${ref#refs/heads/}"
    }

    ###
    # Custom Info Git + Chroot
    custom_info() {
	    outputTMP=""
	    if [ $(git_prompt_info) ]; then
		    outputTMP="[$PR_YELLOW$(git_prompt_info)$PR_BLUE]"
            fi

	    if [ -z outputTMP ]; then
		    return
            fi

	    echo $outputTMP
    }
    
    ###
    # Finally, the prompt.

    PROMPT='$PR_SHIFT_OUT$PR_BLUE\
%(?..$PR_LIGHT_RED%?$PR_BLUE:)\
$(custom_info)\
$PR_LIGHT_BLUE:%(!.$PR_RED.$PR_WHITE)\
$PR_NO_COLOUR '

    RPROMPT='\
$PR_BLUE$PR_SET_CHARSET$PR_STITLE${(e)PR_TITLEBAR}\
[\
$PR_MAGENTA%$PR_PWDLEN<...<%~%<<$PR_BLUE]\
$PR_BLUE$PR_SHIFT_OUT($PR_GREEN%(!.%SROOT%s.%n)$PR_GREEN@%m:%l$PR_BLUE)\
$PR_NO_COLOUR'
#($PR_YELLOW%D{%H:%M:%S - %a,%b%d}$PR_BLUE)$PR_SHIFT_IN$PR_NO_COLOUR'

    PS2='\
$PR_BLUE(\
$PR_LIGHT_GREEN%_$PR_BLUE)\
$PR_NO_COLOUR '
}

setprompt

