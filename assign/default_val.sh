#!/bin/bash

# [Explain colon](https://stackoverflow.com/questions/3224878/what-is-the-purpose-of-the-colon-gnu-bash-builtin)
# [Ref-al](https://superuser.com/questions/423980/colon-command-for-bash)
# [Ref-al](https://unix.stackexchange.com/questions/214556/what-does-colon-in-bash-variable-resolution-syntax-mean)
# [Ref-main](https://unix.stackexchange.com/questions/25425/what-does-param-value-mean)
## This expressionn
if [ -z "$parameter_name" ];then
	parameter_name=$value;
fi

## equal to:
: ${parameter_name:=$value}
