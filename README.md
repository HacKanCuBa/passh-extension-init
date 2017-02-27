# passh init

A [passh](https://github.com/HacKanCuBa/passh) extension that provides a convenient solution to initialize a new password storage and use gpg-id for encryption, extending native init with the posibility of initialize the git repository too, and sign commits from the first one.

If you are using [pass](https://passwordstore.org) - instead of the fork passh - from your distro package manager or from the [official repo](https://git.zx2c4.com/password-store), then this extension won't work. Use [pass initgit](https://github.com/hackan/pass-extension-initgit) instead.

## Usage

```
Usage:
    passh init [--path=subfolder,-p subfolder] [--git,-g] [--sign,-s] gpg-id
        Initialize new password storage and use gpg-id for encryption.
        Selectively reencrypt existing passwords using new gpg-id.
        Additionally, --git or -g initializes the git repository (same as 
        passh git init).
        Optionally, --sign or -s can be passed to temporarily set 
        PASSWORD_STORE_SIGNING_KEY to gpg-ip.
        If PASSWORD_STORE_SIGNING_KEY is set (either by --sign or 
        externally), it will be used to sign gpg-id files and also commits 
        (if git is initialized or already exists). Note that only the first 
        key in PASSWORD_STORE_SIGNING_KEY is used to sign commits! (this is
        a git limitation).
        
More information may be found in the passh-init(1) man page.
```

See `man passh-init` for more information.

## Example

Initialize password store with git and use the key for signing.

	passh init -g -s 09ED85E678DAFE27BD6A409DC3610E1F1AD7A5DB

## Installation

Check the [releases](https://github.com/HacKanCuBa/passh-extension-init/releases) to use a tested signed version of this extension. If you want the bleeding edge version, keep reading.

### Linux

		git clone https://github.com/hackan/passh-extension-init.git
		cd passh-extension-init
		sudo make install

Or simply copy *init.bash* to the pass extension directory (~/.password-store/.extensions by default) and set it executable to enable it: `chmod +x init.bash`.

#### Requirements

In order to use extension with `passh`, you need:

* `passh v1.7.1` or greater. Check the [website](https://passh.hackan.net) on how to obtain it.  
* You need to enable the extensions in passh: `PASSWORD_STORE_ENABLE_EXTENSIONS=true passh`.  
You can create an alias in `.bashrc`: `alias passh='PASSWORD_STORE_ENABLE_EXTENSIONS=true passh'`

## Contribution

Feedback, contributors, pull requests are all very welcome.

## License

    Copyright (C) 2017 HacKan (https://hackan.net)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

