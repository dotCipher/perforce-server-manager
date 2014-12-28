#!/bin/bash

UNIX_USER='perforce'
SERVER_ROOT='/opt/perforce'

BLACK='\033[0;30m'
DARK_GRAY='\033[1;30m'
BLUE='\033[0;34m'
LIGHT_BLUE='\033[1;34m'
GREEN='\033[0;32m'
LIGHT_GREEN='\033[1;32m'
CYAN='\033[0;36m'
LIGHT_CYAN='\033[1;36m'
RED='\033[0;31m'
LIGHT_RED='\033[1;31m'
PURPLE='\033[0;35m'
LIGHT_PURPLE='\033[1;35m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
LIGHT_GRAY='\033[0;37m'
WHITE='\033[1;37m'
NO_COLOR='\033[0m'

# Params: (<func> $1 $2 $3 ...etc)
# $1 = Color to make text
# $2 = Text output
# Description:
# Echoes the text given in the given color
echoColor() {
    # Include color termination at the EOL
    COLORED_STRING="$1$2${NO_COLOR}"
    echo -e $COLORED_STRING
}

usage() {
    echo -e "Usage: psm [OPTIONS]"
    echo
    echoColor $ORANGE "=== OPTIONS ===="
    echo -e " -s start\tStarts the server"
    echo
    echoColor $ORANGE "=== COLORS ==="
    echo -e "Each color represents a different program log level."
    echo -e "Please see below for the color to log level associations."
    echoColor $GREEN "Green - Success"
    echoColor $CYAN "Cyan - Info"
    echoColor $RED "Red - Error"
}

# $1 = Server root
echoStartHeader() {
    echo ""
    echoColor $CYAN "####### Perforce server starting #######"
    echoColor $CYAN "Server root set to:"
    echoColor $CYAN "  $1"
    echoColor $CYAN "########################################"
    echo ""
}

stateStart() {
    echoStartHeader $SERVER_ROOT
    p4d -r $SERVER_ROOT
}

state() {
    VAR_s=$1
    if [[ $VAR_s == 'start' ]]; then
        stateStart
    else
        usage
    fi
}

validateUser() {
    # USER = $1
    # CMD = $2
    if [[ $(whoami) != $1 ]]; then
        echoColor $RED "Error: Invalid user"
        echoColor $CYAN "Must run: $2"
        echoColor $CYAN " as user: $1"
        echoColor $CYAN " and you are: $(whoami)"
        exit
    fi
}

BOOL_s=0
VAR_s=''
OPTSTRING="hs:"
while getopts $OPTSTRING opt; do
    case $opt in
        h)  usage
            exit
            ;;
        s)  VAR_s=${OPTARG}
            BOOL_s=1
            ;;
        \?) usage
            exit
            ;;
    esac
done

shift $((OPTIND-1))

if [[ $BOOL_s -eq 1 ]]; then
    validateUser $UNIX_USER "-s"
    state ${VAR_s}
else
    usage
fi
