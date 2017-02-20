#!/usr/bin/env bash

test_description='Test init extended command --git'
cd "$(dirname "$0")"
. ./setup.sh

test_expect_success 'Test "init --git"' '
    "$PASSH" init --git $KEY3 &&
    [[ -e "$PASSWORD_STORE_DIR/.gpg-id" ]] &&
    [[ $(cat "$PASSWORD_STORE_DIR/.gpg-id") == "$KEY3" ]] &&
    "$PASSH" git status
'

test_expect_success 'Test "init --git" wrong parameter order resistance' '
	"$PASSH" init "$KEY1" --git &&
	"$PASSH" git status
'

test_expect_failure 'Test "init --git" wrong option' '
	"$PASSH" init --git --nonexistent "$KEY4"
'

test_done
