#!/bin/bash

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
