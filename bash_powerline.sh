#!/usr/bin/env bash

__powerline() {
    # Unicode symbols
    readonly GIT_PROMPT_SYMBOL_BRANCH_CHANGE='➦'
    readonly GIT_PROMPT_SYMBOL_ADD='Ⓐ '
    readonly GIT_PROMPT_SYMBOL_DELETE='Ⓓ '
    readonly GIT_PROMPT_SYMBOL_EDIT='Ⓔ '
    readonly GIT_PROMPT_SYMBOL_RENAME='Ⓡ '
    readonly GIT_PROMPT_SYMBOL_MERGE='Ⓜ '
    readonly GIT_PROMPT_SYMBOL_COMMIT='Ⓒ '
    readonly GIT_PROMPT_SYMBOL_PUSH='⬆'
    readonly GIT_PROMPT_SYMBOL_PULL='⬇'

    readonly SYSTEM_PROMPT_SYMBOL_TRUE='✔'
    readonly SYSTEM_PROMPT_SYMBOL_FALSE='✘'
    readonly SYSTEM_PROMPT_SYMBOL_JOBS='⚙'
    readonly SYSTEM_PROMPT_SYMBOL_ROOT='⚡'
    readonly SYSTEM_PROMPT_SYMBOL_AT='@'

    # colorscheme
    #"\[$(tput setab $i)\]"

    readonly DIM="\[$(tput dim)\]"
    readonly REVERSE="\[$(tput rev)\]"
    readonly RESET="\[$(tput sgr0)\]"
    readonly BOLD="\[$(tput bold)\]"

    __git_info() { 
        [ -x "$(which git)" ] || return    # git not found

    }

    ps1() {
        local RETVAL=$?
        local PROMPT_SYMBOL 
        local PROMPT_USER_HOST_COLOR="\[$(tput setaf 2)\]"

        [[ $RETVAL -ne 0 ]] && PROMPT_SYMBOL+="\[$(tput setaf 196)\]$SYSTEM_PROMPT_SYMBOL_FALSE "
        [[ $(jobs -l | wc -l) -gt 0 ]] && PROMPT_SYMBOL+="\[$(tput setaf 30)\]$SYSTEM_PROMPT_SYMBOL_JOBS "
        [[ -n $PROMPT_SYMBOL ]] && PROMPT_SYMBOL="$PROMPT_SYMBOL$RESET"

        [[ $UID -eq 0 ]] && PROMPT_SYMBOL_USER="\[$(tput setaf 172)\]$SYSTEM_PROMPT_SYMBOL_ROOT" && PROMPT_USER_HOST_COLOR="\[$(tput setaf 172)\]"

        local PROMPT_DIR="\[$(tput setaf 4)\]\w $RESET"
        local PROMPT_USER_HOST="$PROMPT_SYMBOL$PROMPT_USER_HOST_COLOR\u\@\h${RESET}"
        
        PS1_U="$PROMPT_DIR"
        PS1_D="$PROMPT_USER_HOST_COLOR$PROMPT_USER_HOST $PROMPT_SYMBOL_USER $RESET"
        PS1="${PS1_U}\n${PS1_D}"
    }

    PROMPT_COMMAND=ps1
}

__powerline
unset __powerline
