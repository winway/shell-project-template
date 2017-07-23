#! /bin/bash
#

function SCRIPTENTRY () {
    logger_trace "####SCRIPTENTRY####: $(basename $0)"
}

function SCRIPTEXIT(){
    logger_trace "####SCRIPTEXIT####: $(basename $0)"
}

function FUNCENTRY () {
    logger_trace "####FUNCENTRY####: ${FUNCNAME[1]}"
}

function FUNCEXIT () {
    logger_trace "####FUNCEXIT####: ${FUNCNAME[1]}"
}

#
# usage: CMD_EXECUTOR pass|return|exit cmd
function CMD_EXECUTOR () {
    local _exitmode_="$1"
    local _cmd_="$2"

    if [[ $_exitmode_ != pass ]] && [[ $_exitmode_ != return ]] && [[ $_exitmode_ != exit ]]
    then
        logger_error "Unknown exitmode: $_exitmode_"
        exit
    fi

    logger_info "CMD_EXECUTOR(${_exitmode_}): ${_cmd_}"

    eval $_cmd_
    if [[ $? -ne 0 ]]
    then
        if [[ $_exitmode_ = return ]] || [[ $_exitmode_ = exit ]]
        then
            logger_error "CMD_EXECUTOR: $_cmd_ failed"
            $_exitmode_
        elif [[ $_exitmode_ = pass ]]
        then
            logger_info "CMD_EXECUTOR: $_cmd_ failed"
        fi
    else
        logger_info "CMD_EXECUTOR: $_cmd_ succeed"
    fi
}

#
# usage: singleton_lock _exitfunc_
function singleton_lock () {
    FUNCENTRY

    local _appname_=$(basename $0)
    local _exitfunc_=$1

    # clear invalid symbolic link first
    find /dev/shm/ -maxdepth 0 -type l -follow -exec unlink {} \;

    # check whether another shell script is running
    if [[ -e /dev/shm/${_appname_} ]]
    then
        logger_error "Another instance is running"
        ps -elf | grep ${_appname_} | grep -v grep
        exit 1
    else
        logger_info "Lock succeed"
    fi

    ln -s /proc/$$ /dev/shm/${_appname_}

    trap "singleton_unlock ${_exitfunc_}" 0 1 2 3 9 15 22 24

    FUNCEXIT
}

#
# usage: singleton_unlock _exitfunc_
function singleton_unlock () {
    FUNCENTRY

    local _appname_=$(basename $0)
    local _exitfunc_=$1

    if [[ -n ${_exitfunc_} ]]
    then
        logger_info "Call _exitfunc_: ${_exitfunc_}"
        eval ${_exitfunc_}
    fi

    unlink /dev/shm/${_appname_}

    FUNCEXIT
}

