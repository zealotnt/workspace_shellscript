#!/bin/bash

# This script will remove all of the ANSI-Color code printed by the application
# Usage:
# ./color_filter.sh <some-app> <app's arguments>

# References Resources:
# https://eklitzke.org/stdout-buffering
# https://unix.stackexchange.com/questions/25372/turn-off-buffering-in-pipe
# http://www.pixelbeat.org/programming/stdio_buffering/
# https://www.perkin.org.uk/posts/how-to-fix-stdio-buffering.html
# http://www.tldp.org/LDP/abs/html/io-redirection.html

# FILTER_REMOVE_ALL="s,Message,,g"
# FILTER_REMOVE_ALL="s,1,1,g"
# FILTER_REMOVE_ALL="s,\x1B\[[0-9;]*[a-zA-Z],,g"
FILTER_REMOVE_ALL="s,.\[[0-9;]*[a-zA-Z],,g"

ColorFilter() {
	stdbuf -oL -eL $@ 2>&1 | stdbuf -oL -eL sed -r $FILTER_REMOVE_ALL
	ret=${PIPESTATUS[0]}
	return $ret
}

ColorFilter $@
exit $?
