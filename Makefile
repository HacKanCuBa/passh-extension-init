PROG ?= init
PREFIX ?= /usr
DESTDIR ?=
LIBDIR ?= $(PREFIX)/lib
SYSTEM_EXTENSION_DIR ?= $(LIBDIR)/password-store/extensions
MANDIR ?= $(PREFIX)/share/man

all:
	@echo "passh-$(PROG) is a shell script and does not need compilation, it can be simply executed."
	@echo ""
	@echo "To install it try \"make install\" instead."
	@echo
	@echo "To run passh $(PROG) one needs to have some tools installed on the system:"
	@echo "     passh"

install:
	@install -v -d "$(DESTDIR)$(MANDIR)/man1" && install -m 0644 -v passh-$(PROG).1 "$(DESTDIR)$(MANDIR)/man1/passh-$(PROG).1"
	@install -v -d "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/"
	@install -Dm0755 $(PROG).bash "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/$(PROG).bash"
	@echo
	@echo "passh-$(PROG) is installed succesfully"
	@echo

uninstall:
	@rm -vrf \
		"$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/$(PROG).bash" \
		"$(DESTDIR)$(IMPORTERS_DIR)/" \
		"$(DESTDIR)$(MANDIR)/man1/passh-$(PROG).1" \

TESTS = $(sort $(wildcard tests/t[0-9][0-9][0-9][0-9]-*.sh))

test: $(TESTS)

$(TESTS):
	@$@ $(PASS_TEST_OPTS)

clean:
	@rm -rf tests/password-store/ tests/test-results/ tests/trash\ directory.*/ tests/gnupg/random_seed

lint:
	shellcheck -s bash $(PROG).bash


.PHONY: install uninstall test lint clean $(TESTS)
