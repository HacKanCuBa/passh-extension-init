#!/usr/bin/env bash

test_description='Test init extended command --sign and --git option'
cd "$(dirname "$0")"
. ./setup.sh

test_expect_success 'Test "init --sign --git"' '
	"$PASSH" init --sign --git "$KEY1" &&
	[[ -e "$PASSWORD_STORE_DIR/.gpg-id" ]] &&
	[[ $(cat "$PASSWORD_STORE_DIR/.gpg-id") == "$KEY1" ]] &&
	[[ -e "$PASSWORD_STORE_DIR/.gpg-id.sig" ]] &&
	gpg --verify "$PASSWORD_STORE_DIR/.gpg-id.sig" &&
	"$PASSH" git status &&
	"$PASSH" git verify-commit HEAD
'

test_expect_success 'Test "init --sign --git" wrong parameter order resistance' '
	"$PASSH" init "$KEY2" --sign --git &&
	[[ -e "$PASSWORD_STORE_DIR/.gpg-id" ]] &&
	[[ $(cat "$PASSWORD_STORE_DIR/.gpg-id") == "$KEY2" ]] &&
	[[ -e "$PASSWORD_STORE_DIR/.gpg-id.sig" ]] &&
	gpg --verify "$PASSWORD_STORE_DIR/.gpg-id.sig" &&
	"$PASSH" git status &&
	"$PASSH" git verify-commit HEAD
'

test_expect_success 'Test new entry must have signed commit' '
	"$PASSH" generate new 5 &&
	"$PASSH" git status &&
	"$PASSH" git verify-commit HEAD
'

test_expect_failure 'Test "init --sign --git" wrong key' '
	"$PASSH" init --git --sign 0
'

test_expect_failure 'Test "init --sign --git" wrong option' '
	"$PASSH" init --sign --git --nonexistent "$KEY4"
'

test_expect_failure 'Test tampered gpg-id must exit immediately' '
	export PASSWORD_STORE_SIGNING_KEY="$KEY1" &&
	echo 1 >> "$PASSWORD_STORE_DIR/.gpg-id.sig" &&
	"$PASSH" generate other 5
'

test_done
