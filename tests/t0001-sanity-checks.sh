#!/usr/bin/env bash

test_description='Sanity checks'
cd "$(dirname "$0")"
. ./setup.sh

test_expect_success 'Make sure we can run passh' '
	"$PASSH" --help | grep "the standard unix password manager"
'

test_expect_success 'Make sure the extension is enabled' '
	[[ -x "$PASSWORD_STORE_EXTENSIONS_DIR/$EXTENSION.bash" ]]
'

test_expect_success 'Make sure the extension is being executed' '
	[[ -n "$("$PASSH" help | grep -A999 -P "^From extensions:$" | grep "$EXTENSION" )" ]]
'

test_done
