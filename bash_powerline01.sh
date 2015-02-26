#!/usr/bin/env bash

__powerline() {
    # Unicode symbols
    readonly SEGMENT_SEPARATOR='⮀'
    readonly GIT_BRANCH_SYMBOL='⭠ '
    readonly GIT_BRANCH_CHANGED_SYMBOL='✚'
    readonly GIT_BRANCH_COMMIT_SYMBOL='●'
    readonly GIT_NEED_PUSH_SYMBOL='⬆'
    readonly GIT_NEED_PULL_SYMBOL='⬇'

    # colorscheme
    readonly FG_Black="\[$(tput setaf 0)\]"
    readonly FG_Red="\[$(tput setaf 1)\]"
    readonly FG_Green="\[$(tput setaf 2)\]"
    readonly FG_Yellow="\[$(tput setaf 3)\]"
    readonly FG_Violet="\[$(tput setaf 4)\]"
    readonly FG_Magenta="\[$(tput setaf 5)\]"
    readonly FG_Cyan="\[$(tput setaf 6)\]"
    readonly FG_White="\[$(tput setaf 7)\]"

    readonly BG_Black="\[$(tput setab 0)\]"
    readonly BG_Red="\[$(tput setab 1)\]"
    readonly BG_Green="\[$(tput setab 2)\]"
    readonly BG_Yellow="\[$(tput setab 3)\]"
    readonly BG_Violet="\[$(tput setab 4)\]"
    readonly BG_Magenta="\[$(tput setab 5)\]"
    readonly BG_Cyan="\[$(tput setab 6)\]"
    readonly BG_White="\[$(tput setab 7)\]"

    readonly DIM="\[$(tput dim)\]"
    readonly REVERSE="\[$(tput rev)\]"
    readonly RESET="\[$(tput sgr0)\]"
    readonly BOLD="\[$(tput bold)\]"

    __git_info() { 
        [ -x "$(which git)" ] || return    # git not found

        # get current branch name or short SHA1 hash for detached head
        local branch="$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --always 2>/dev/null)"
        [ -n "$branch" ] || return  # git branch not found

        local marks
        local BG_COLOR="$BG_Green"
        local FG_COLOR="$FG_Green"

        # branch is modified?
        [ -n "$(git status --porcelain)" ] && marks+=" $GIT_BRANCH_CHANGED_SYMBOL"

        # how many commits local branch is ahead/behind of remote?
        local stat="$(git status --porcelain --branch | grep '^##' | grep -o '\[.\+\]$')"
        local aheadN="$(echo $stat | grep -o 'ahead \d\+' | grep -o '\d\+')"
        local behindN="$(echo $stat | grep -o 'behind \d\+' | grep -o '\d\+')"
        [ -n "$aheadN" ] && marks+=" $GIT_NEED_PUSH_SYMBOL $aheadN"
        [ -n "$behindN" ] && marks+=" $GIT_NEED_PULL_SYMBOL $behindN"

        # print the git branch segment without a trailing newline
        [[ -n $marks ]] && BG_COLOR="$BG_Yellow" && FG_COLOR="$FG_Yellow"
        printf "$BG_COLOR$FG_Violet$SEGMENT_SEPARATOR $FG_Black$GIT_BRANCH_SYMBOL$branch$marks $RESET$FG_COLOR$SEGMENT_SEPARATOR$RESET"
    }

    ps1() {
        local RETVAL=$?
        # Check the exit code of the previous command and display different
        # colors in the prompt accordingly.
        local Symbols 
        local Dir_Separator
        [[ $RETVAL -ne 0 ]] && Symbols+="$FG_Red ✘"
        [[ $UID -eq 0 ]] && Symbols+="$FG_Yellow ⚡"
        [[ $(jobs -l | wc -l) -gt 0 ]] && Symbols+="$FG_Cyan ⚙"
        [[ $UID -eq 0 ]] && Symbols+="$FG_Yellow \u@\h"
        [[ -n $Symbols ]] && Symbols="$BG_Black$Symbols $RESET$BG_Violet$FG_Black$SEGMENT_SEPARATOR$RESET"
        PSdir="$BG_Violet$FG_Black \w $RESET"
        [[ !(-n $(__git_info)) ]] && Dir_Separator="$FG_Violet$SEGMENT_SEPARATOR$RESET"
        PS1="$Symbols$PSdir$Dir_Separator$(__git_info) "
    }

    PROMPT_COMMAND=ps1
}

__powerline
unset __powerline
