#!/usr/bin/env bash
# passh init - Passh (Password Store fork) Extension
# Copyright (C) 2017 HacKan <hackan@gmail.com>.
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

help_init() {
	cat <<-_EOF
	    $PROGRAM init [--path=subfolder,-p subfolder] [--git,-g] [--sign,-s] gpg-id
	        Initialize new password storage and use gpg-id for encryption.
	        Selectively reencrypt existing passwords using new gpg-id.
	        Additionally, --git or -g initializes the git repository (same as 
	        $PROGRAM git init).
	        Optionally, --sign or -s can be passed to temporarily set 
	        PASSWORD_STORE_SIGNING_KEY to gpg-ip.
	        If PASSWORD_STORE_SIGNING_KEY is set (either by --sign or 
	        externally), it will be used to sign gpg-id files and also commits 
	        (if git is initialized or already exists). Note that only the first 
	        key in PASSWORD_STORE_SIGNING_KEY is used to sign commits! (this is
	        a git limitation).
	_EOF
}

cmd_init_usage() {
	cat <<-_EOF
	Usage:
	$(help_init)
	        
	More information may be found in the passh-init(1) man page.
	_EOF
}

override_function cmd_init

cmd_init() {
	local opts sign=0 st_path="" git=0
	opts="$($GETOPT -o pgs -l path,git,sign -n "$PROGRAM" -- "$@")"
	local err=$?
	eval set -- "$opts"
	while true; do case $1 in
		-p|--path) st_path="$2"; shift 2 ;;
		-g|--git)  git=1; shift ;;
		-s|--sign) sign=1; shift ;;
		--) shift; break ;;
	esac done

	[[ $err -ne 0 || $# -lt 1 || $# -gt 5 ]] && die "Usage: $PROGRAM $COMMAND [--help,-h] [--path=subfolder,-p subfolder] [--git,-g] [--sign,-s] gpg-id"
	
	local -a gpg_id
	gpg_id=( $@ )

	[[ $sign -eq 1 ]] && export PASSWORD_STORE_SIGNING_KEY="${gpg_id[0]}"

	# Init passh
	#local passh_init="$(sed -nE "/^(function)?\s?cmd_init\(\)/,/^}/p" "$(which passh)")"
	#passh_init="passh_cmd_init${passh_init#cmd_init}"
	#eval "$passh_init"
	for id in "${gpg_id[@]}"; do
		$GPG -k "$id" > /dev/null || die "GPG-ID '$id' not found"
	done
	if [[ -n "$st_path" ]]; then 
		pass_cmd_init -p "$st_path" "${gpg_id[@]}"
	else
		pass_cmd_init "${gpg_id[@]}"
	fi
	mkdir -p "$EXTENSIONS" > /dev/null 2>&1
	
	if [[ $git -eq 1 ]]; then
		set_git "$PREFIX/"
		INNER_GIT_DIR="$PREFIX"

		# Init git
		git -C "$INNER_GIT_DIR" init || die "Initializing git failed"

		# Enable commit signing if key set
		if [[ -n "$PASSWORD_STORE_SIGNING_KEY" ]]; then
			for fingerprint in $PASSWORD_STORE_SIGNING_KEY; do
				git -C "$INNER_GIT_DIR" config --local --add user.signingkey "$fingerprint"
				# git can't have more than one signing key.
				# you can set several, but only the last one is used.
				break
			done
			git -C "$INNER_GIT_DIR"  config --local --bool --add pass.signcommits true
		fi

		git_add_file "$PREFIX" "Add current contents of password store."

		echo '*.gpg diff=gpg' > "$PREFIX/.gitattributes"
		git_add_file "$PREFIX/.gitattributes" "Configure git repository for gpg file diff."
		git -C "$INNER_GIT_DIR" config --local diff.gpg.binary true
		git -C "$INNER_GIT_DIR" config --local diff.gpg.textconv "$GPG -d ${GPG_OPTS[*]}"
	fi
}

[[ "$1" == "help" || "$1" == "--help" || "$1" == "-h" ]] && cmd_init_usage && exit 0

cmd_init "$@"
