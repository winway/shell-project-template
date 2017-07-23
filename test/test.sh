#! /bin/sh
#

# load log4sh

. $(dirname $(readlink -f $0))/../lib/bootstrap.sh

function on_exit() {
    logger_info "on_exit"
}

singleton_lock on_exit

# say hello to the world
logger_trace "Hello, trace!"
logger_debug "Hello, debug!"
logger_info "Hello, info!"
logger_error "Hello, error!"

argsparse_allow_no_argument yes

argsparse_use_option option1 "An option."
argsparse_use_option option2 "Another option." short:2
argsparse_use_option option3 "A 3rd option." short:3 value type:directory mandatory

argsparse_parse_options "$@"

argsparse_report

argsparse_is_option_set option1 && logger_info "option1 set"
argsparse_is_option_set option2 && logger_info "option2 set"

DX=a
X=${program_options[option3]:-$DX}

logger_info $X

sleep 1

CMD_EXECUTOR return "ls /"
CMD_EXECUTOR return "ls asd"
CMD_EXECUTOR exit "ls asd"

logger_info "Done"
