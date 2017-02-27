#!/usr/bin/env bash

test_description='Requirements checks'
cd "$(dirname "$0")"
. ./setup.sh

test_expect_success 'Make sure passh version is adequate' '
	PASSH_VERSION="$("$PASSH" version | grep v | tail -n 1 | cut -d"v" -f2 | cut -d" " -f1)" &&
	[[ "$PASSH_VERSION" =~ ^1\.7\.[1-9][0-9]* ]]
'

test_done
