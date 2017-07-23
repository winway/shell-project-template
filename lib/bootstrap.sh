#! /bin/bash 
#

. /etc/profile

set -e

SCRIPT=$(readlink -f "$BASH_SOURCE")

__APPNAME__=myproject

__HOMEDIR__=$(dirname $(dirname "$SCRIPT"))
__BINDIR__=${__HOMEDIR__}/bin
__CONFDIR__=${__HOMEDIR__}/conf
__LIBDIR__=${__HOMEDIR__}/lib
__SRCDIR__=${__HOMEDIR__}/src
__LOGDIR__=/opt/logs/${__APPNAME__}
__TMPDIR__=/data/.${__APPNAME__}

mkdir -p ${__LOGDIR__}
mkdir -p ${__TMPDIR__}

# check system dir
[[ -d ${__HOMEDIR__} ]]
[[ -d ${__BINDIR__} ]]
[[ -d ${__CONFDIR__} ]]
[[ -d ${__LIBDIR__} ]]
[[ -d ${__SRCDIR__} ]]
[[ -d ${__LOGDIR__} ]]
[[ -d ${__TMPDIR__} ]]

export __APPNAME__
export __HOMEDIR__
export __BINDIR__
export __CONFDIR__
export __LIBDIR__
export __SRCDIR__
export __LOGDIR__
export __TMPDIR__

set +e

LOG4SH_CONFIGURATION="${__CONFDIR__}/log4sh.properties" . ${__LIBDIR__}/log4sh
. ${__LIBDIR__}/argsparse.sh
. ${__LIBDIR__}/utils.sh

export PATH=${PATH}:${__LIBDIR__}

logger_trace "============SYSTEM ENV INITIALIZATION============"
logger_trace "__APPNAME__: ${__APPNAME__}"
logger_trace "__HOMEDIR__: ${__HOMEDIR__}"
logger_trace "__BINDIR__: ${__BINDIR__}"
logger_trace "__CONFDIR__: ${__CONFDIR__}"
logger_trace "__LIBDIR__: ${__LIBDIR__}"
logger_trace "__SRCDIR__: ${__SRCDIR__}"
logger_trace "__LOGDIR__: ${__LOGDIR__}"
logger_trace "__TMPDIR__: ${__TMPDIR__}"
logger_trace "============SYSTEM ENV INITIALIZATION============"
