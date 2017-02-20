#!/usr/bin/env bash

test_description='Test init extended command --sign option'
cd "$(dirname "$0")"
. ./setup.sh

test_expect_success 'Test "init --sign"' '
	"$PASSH" init --sign $KEY3 &&
	[[ -e "$PASSWORD_STORE_DIR/.gpg-id" ]] &&
	[[ $(cat "$PASSWORD_STORE_DIR/.gpg-id") == "$KEY3" ]] &&
	[[ -e "$PASSWORD_STORE_DIR/.gpg-id.sig" ]] &&
	gpg --verify "$PASSWORD_STORE_DIR/.gpg-id.sig"
'

test_expect_success 'Test "init --sign" wrong parameter order resistance' '
	"$PASSH" init "$KEY1" --sign
'

test_expect_success 'Test "init --sign" multiple gpg key' '
	"$PASSH" init --sign $KEY1 $KEY2 $KEY3 &&
	[[ -e "$PASSWORD_STORE_DIR/.gpg-id" ]] &&
	[[ -e "$PASSWORD_STORE_DIR/.gpg-id.sig" ]] &&
	gpg --verify "$PASSWORD_STORE_DIR/.gpg-id.sig"
'

test_expect_failure 'Test "init --sign" wrong key' '
	"$PASSH" init --sign 0
'

test_expect_failure 'Test "init --sign" wrong option' '
	"$PASSH" init --sign --nonexistent "$KEY4"
'

test_done
