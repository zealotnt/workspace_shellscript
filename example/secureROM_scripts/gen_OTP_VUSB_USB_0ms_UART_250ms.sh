#!/bin/sh

# Copyright (C) 2012-2014 Maxim Integrated Products, Inc., All Rights Reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL MAXIM INTEGRATED BE LIABLE FOR ANY CLAIM, DAMAGES
# OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# Except as contained in this notice, the name of Maxim Integrated
# Products, Inc. shall not be used except as stated in the Maxim Integrated
# Products, Inc. Branding Policy.
#
# The mere transfer of this software does not imply any licenses
# of trade secrets, proprietary technology, copyrights, patents,
# trademarks, maskwork rights, or any other form of intellectual
# property whatsoever. Maxim Integrated Products, Inc. retains all
# ownership rights.

usage() {
    echo
    echo "Generates an SCP script for flashing a signed binary executable using MAX32550 SecureROM."
    echo "Copyright (c) 2012-2014 Maxim Integrated Products, Inc."
    echo
    echo "*** CAUTION: This tool is not PCI compliant. It is for development purposes only. ***"
    echo
    echo " MAX32550 pre-requisites:"
    echo "   - For MAX32550 rev A2 and above"
    echo "   - Chip must be in Phase 4"
    echo "   - OTP \"binary location\" must have been set equal to destination address defined in this script"
    echo "   - CRK in OTP must match the signing key invoked here"
    echo
#    echo " Syntax: build_application.sh [options]... <execfile> <dir> <signing_keyfile>";
    echo " Syntax: build_application.sh <execfile> <dir> <signing_keyfile> <flash_type>";
    echo
#    echo "    --soc=<rev>       = chip name (e.g., A2) or ROM version"
    echo "    <input>           = signed binary file (extension .sbin) to be flashed"
    echo "    <dir>             = target directory for storing the generated packets"
    echo "    <signing_keyfile> = file containing signing key in UCL format"
    echo
    echo " NOTE: The target directory (<dir>) is fully erased before processing."
    echo
    echo "See also: sendscp.sh to run the SCP session generated by this script."
    echo "See also: sign_exec_for_bootrom.sh for generating the signed (.sbin) file."

}

# Parameters
verbose=no
soc=

while [ $# -ge 1 ]; do
	case $1 in
	--soc=)	echo >&2 "error: No ROM/chip version specified"
		exit 4
		;;
	--soc=*)
		soc=${1#--soc=}
		;;
	--verbose)
		verbose=no
		;;
	--)	shift
		break
		;;
	-*)	echo >&2 "error: Unknown option \`$1'"
		exit 5
		;;
	*)	break
		;;
	esac
	shift
done
readonly soc verbose

case $# in
3)	output=$1
	readonly key=$2
	;;
2)  output=$1
	readonly key=$2
	;;
*)	usage >&2
	exit 2
	;;
esac

TOOLDIR=$(readlink -e -- "$(dirname -- "$0")")
KEYFILE=$(readlink -e -- "$key")  || {
	echo >&2 "error: Private key \`$key' does not exist"
	exit 3
}

#remove end slash if any
output=${output%/}

rm -rf -- "$output"
mkdir  -- "$output"

OUTPUTDIR=$(readlink -e -- "$output")

cd -- "$output"   ||  exit 10

readonly bin_version=$( echo $built_for | tr -d ' ' )

# If an explicit chip/ROM (--soc=...) was specified, use that
# (warning if if seems to differ from what we extracted from the input);
# Otherwise (by default), use whatever ROM version we extracted from the input.
if [ -z "$soc" ]; then
	ROMVERSION=$bin_version
elif use_rom=$( $TOOLDIR/../lib/rom/findrom.sh "$soc" ); then
	ROMVERSION=${use_rom##*/}
else
	exit 21
fi

#echo "ROMVERSION=$ROMVERSION"
#romdir=$( $TOOLDIR/../lib/rom/findrom.sh "$ROMVERSION" )  ||  exit 22
#readonly romdir

#which objcopy >/dev/null  || {
#	echo >&2 "\
#error: \`objcopy' utility not available.
#   You should install the \"binutils\" package."
#	exit 30
#}

#flash_dest=0x10000000

    cat >> sb_script.txt << EOF
write-timeout U 0000
write-timeout V 0000
write-timeout 0 FA00
EOF

$TOOLDIR/../lib/session_build.exe session_mode=SCP_ANGELA_ECDSA verbose=no output_file=$OUTPUTDIR/session_angela_binary pp=ECDSA addr_offset=00000000 chunk_size=4094 script_file=sb_script.txt ecdsa_file=$KEYFILE  &&
	LC_ALL=C  ls -1 *.packet >packet.list


if [ $? -ne 0 ] ; then
echo "ERROR."
exit 1
fi

echo "Generated SCP packets in: $output"
echo "Use sendscp.sh <serial_port_spec> $output to run the SCP script generated by this utility."
echo "SUCCESS."
