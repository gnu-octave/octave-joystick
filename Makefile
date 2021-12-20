## Copyright 2021 John Donoghue
##
## Copying and distribution of this file, with or without modification,
## are permitted in any medium without royalty provided the copyright
## notice and this notice are preserved.  This file is offered as-is,
## without any warranty.

## Makefile to simplify Octave Forge package maintenance tasks
TOPDIR := $(shell pwd)
PACKAGE_REPO_DIR ?= $(TOPDIR)

## Some shell programs
MD5SUM    ?= md5sum
SED       ?= sed
GREP      ?= grep
TAR       ?= tar
CUT       ?= cut
TR        ?= tr
TEXI2PDF  ?= texi2pdf -q

### Note the use of ':=' (immediate set) and not just '=' (lazy set).
### http://stackoverflow.com/a/448939/1609556
PACKAGE := $(shell $(GREP) "^Name: " DESCRIPTION | $(CUT) -f2 -d" " | \
$(TR) '[:upper:]' '[:lower:]')
VERSION := $(shell $(GREP) "^Version: " DESCRIPTION | $(CUT) -f2 -d" ")
DEPENDS := 


## Detect which VCS is used
vcs := $(if $(wildcard $(PACKAGE_REPO_DIR)/.hg),hg,$(if $(wildcard $(PACKAGE_REPO_DIR)/.git),git,unknown))
ifeq ($(vcs),hg)
release_dir_dep := .hg/dirstate
HG           := hg
HG_CMD        = $(HG) --config alias.$(1)=$(1) --config defaults.$(1)= $(1)
HG_ID        := $(shell $(call HG_CMD,identify) --id | sed -e 's/+//' )
TIMESTAMP    := $(firstword $(shell $(call HG_CMD,log) --rev $(HG_ID) --template '{date|hgdate}'))
endif
ifeq ($(vcs),git)
release_dir_dep := .git/index
GIT          := git
TIMESTAMP    := $(firstword $(shell $(GIT) log -n1 --date=unix --format="%ad"))
endif

TAR_REPRODUCIBLE_OPTIONS := --sort=name --mtime="@$(TIMESTAMP)" --owner=0 --group=0 --numeric-owner
TAR_OPTIONS  := --format=ustar $(TAR_REPRODUCIBLE_OPTIONS)

## This are the files that will be created for the releases.
TARGET_DIR      := release
RELEASE_DIR     := $(TARGET_DIR)/$(PACKAGE)-$(VERSION)
RELEASE_TARBALL := $(TARGET_DIR)/$(PACKAGE)-$(VERSION).tar.gz
HTML_DIR        := $(TARGET_DIR)/$(PACKAGE)-html
HTML_TARBALL    := $(TARGET_DIR)/$(PACKAGE)-html.tar.gz

REAL_TARGET_DIR  := $(realpath .)/$(TARGET_DIR)
INSTALLATION_DIR := $(REAL_TARGET_DIR)/.installation
PACKAGE_LIST     := $(INSTALLATION_DIR)/.octave_packages
INSTALL_STAMP    := $(INSTALLATION_DIR)/.install_stamp

## Octave binaries
MKOCTFILE ?= mkoctfile
OCTAVE    ?= octave --no-gui

## Remove if not needed, most packages do not have PKG_ADD directives.
M_SOURCES   := $(wildcard inst/*.m)
CC_SOURCES  := $(wildcard src/*.cc)
PKG_ADD     := $(shell $(GREP) -sPho '(?<=(//|\#\#) PKG_ADD: ).*' \
                         $(CC_SOURCES) $(M_SOURCES))
AUTOCONF_TARGETS := src/configure src/Makefile

## Targets that are not filenames.
## https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html
.PHONY: help dist html release install all check run clean autoconf_target

## make will display the command before runnning them.  Use @command
## to not display it (makes specially sense for echo).
help:
	@echo "Targets:"
	@echo "   dist             - Create $(RELEASE_TARBALL) for release"
	@echo "   html             - Create $(HTML_TARBALL) for release"
	@echo "   release          - Create both of the above and show md5sums"
	@echo
	@echo "   install          - Install the package in GNU Octave"
	@echo "   all              - Build all oct files"
	@echo "   run              - Run Octave with development in PATH (no install)"
	@echo "   check            - Execute package tests (w/o install)"
	@echo "   doctest          - Tests only the help text via the doctest package"
	@echo
	@echo "   clean            - Remove releases, html documentation, and oct files"

# dist and html targets are only PHONY/alias targets to the release
# and html tarballs.
dist: $(RELEASE_TARBALL)
html: $(HTML_TARBALL)

# An implicit rule with a recipe to build the tarballs correctly.
%.tar.gz: %
	$(TAR) -cf - $(TAR_OPTIONS) -C "$(TARGET_DIR)/" "$(notdir $<)" | gzip -9n > "$@"

# Some packages are distributed outside Octave Forge in non tar.gz format.
%.zip: %
	cd "$(TARGET_DIR)" ; zip -9qr - "$(notdir $<)" > "$(notdir $@)"

# Create the unpacked package.
$(RELEASE_DIR): $(PACKAGE_REPO_DIR)/$(release_dir_dep)
	@echo "Creating package version $(VERSION) release ..."
	$(RM) -r "$@"
ifeq (${vcs},hg)
	$(HG) archive --exclude ".hg*" --type files "$@"
endif
ifeq (${vcs},git)
	$(GIT) archive --format=tar --prefix="$@/" HEAD | $(TAR) -x
	$(RM) "$@/.gitignore"
endif

#	cp "$@/examples/"*.m "$@/inst/"
	$(MAKE) PACKAGE_REPO_DIR=$(PACKAGE_REPO_DIR) -C "$@" docs
	cd "$@" && rm -rf "devel/" && rm -rf "deprecated/" && $(RM) -f doc/mkfuncdocs.py
#	cd "$@/src" && aclocal -Im4 && autoconf && $(RM) -r "src/autom4te.cache"
	cd "$@/src" && $(SHELL) ./autogen.sh && $(RM) -r "autom4te.cache"
	cd "$@" && $(RM) Makefile
	chmod -R a+rX,u+w,go-w "$@"

.PHONY: docs
docs: doc/$(PACKAGE).pdf doc/$(PACKAGE).info

.PHONY: clean-docs
clean-docs:
	$(RM) -f doc/$(PACKAGE).info
	$(RM) -f doc/$(PACKAGE).pdf
	$(RM) -f doc/functions.texi

doc/$(PACKAGE).pdf: doc/$(PACKAGE).texi doc/functions.texi
	cd doc && SOURCE_DATE_EPOCH=$(TIMESTAMP) $(TEXI2PDF) $(PACKAGE).texi
	# remove temp files
	cd doc && $(RM) -f $(PACKAGE).aux $(PACKAGE).cp $(PACKAGE).cps $(PACKAGE).fn  $(PACKAGE).fns $(PACKAGE).log $(PACKAGE).toc

doc/$(PACKAGE).info: doc/$(PACKAGE).texi doc/functions.texi
	cd doc && SOURCE_DATE_EPOCH=$(TIMESTAMP) $(MAKEINFO) $(PACKAGE).texi

doc/functions.texi:
	cd doc && ./mkfuncdocs.py --allowscan --src-dir=../inst/ ../INDEX | $(SED) 's/@seealso/@xseealso/g' > functions.texi

run_in_place = $(OCTAVE) --eval ' pkg ("local_list", "$(PACKAGE_LIST)"); ' \
                         --eval ' pkg ("load", "$(PACKAGE)"); '

# install is a prerequesite to the html directory (note that the html
# tarball will use the implicit rule for ".tar.gz" files).
html_options = --eval 'options = get_html_options ("octave-forge");' \
               --eval 'options.package_doc = "$(PACKAGE).texi";'

$(HTML_DIR): install
	@echo "Generating HTML documentation. This may take a while ..."
	$(RM) -r "$@"
	$(run_in_place) \
	  --eval "pkg load generate_html; " \
	  $(html_options)               \
	  --eval 'generate_package_html ("${PACKAGE}", "$@", options);'
	chmod -R a+rX,u+w,go-w $@

# To make a release, build the distribution and html tarballs.
release: dist html
	@$(MD5SUM) $(RELEASE_TARBALL) $(HTML_TARBALL)
	@echo "Upload @ https://sourceforge.net/p/octave/package-releases/new/"
	@echo "    and inform to rebuild release with '$$(hg id)'"
	@echo 'Execute: hg tag "release-${VERSION}"'

octave_install_commands = \
' llist_path = pkg ("local_list"); \
  mkdir ("$(INSTALLATION_DIR)"); \
  load (llist_path); \
  local_packages(cellfun (@ (x) strcmp ("$(PACKAGE)", x.name), local_packages)) = []; \
  save ("$(PACKAGE_LIST)", "local_packages"); \
  pkg ("local_list", "$(PACKAGE_LIST)"); \
  pkg ("prefix", "$(INSTALLATION_DIR)", "$(INSTALLATION_DIR)"); \
  pkg ("install", "-local", "-verbose", "$(RELEASE_TARBALL)"); '


install: $(RELEASE_TARBALL)
	@echo "Installing package locally ..."
	$(OCTAVE) --eval $(octave_install_commands)
	touch $(INSTALL_STAMP)

clean-install:
	@echo "## Cleaning installation under $(INSTALLATION_DIR) ..."
	-$(RM) -r $(INSTALLATION_DIR)
	@echo

clean: clean-docs clean-install
	$(RM) -r $(RELEASE_DIR) $(RELEASE_TARBALL) $(HTML_TARBALL) $(HTML_DIR)
	$(MAKE) -C src clean

distclean: clean-docs clean-install
	-$(RM) -r $(RELEASE_DIR) $(RELEASE_TARBALL) $(HTML_TARBALL) $(HTML_DIR)
	-$(RM) -r inst/test
	$(MAKE) -C src distclean

#
# Recipes for testing purposes
#
src/configure: src/configure.ac
	cd src && $(SHELL) ./autogen.sh

src/Makefile: src/Makefile.in src/configure
	cd src && ./configure

autoconf_target: $(AUTOCONF_TARGETS)

$(INSTALL_STAMP): $(RELEASE_TARBALL)
	@echo "Installing package under $(INSTALLATION_DIR) ..."
	$(OCTAVE) --eval $(octave_install_commands)
	touch $(INSTALL_STAMP)

# Build any requires oct files.  Some packages may not need this at all.
# Other packages may require a configure file to be created and run first.
all: autoconf_target $(CC_SOURCES)
	$(MAKE) -C src/

# Start an Octave session with the package directories on the path for
# interactice test of development sources.
run: all
	$(OCTAVE) --silent --persist --path "$(TOPDIR)/inst/" --path "$(TOPDIR)/src/" --path "$(TOPDIR)/examples/" \
	  --eval 'if(!isempty("$(DEPENDS)")); pkg load $(DEPENDS); endif;' \
	  --eval '$(PKG_ADD)'

runlocal: $(INSTALL_STAMP)
	$(run_in_place) --persist 

# Test example blocks in the documentation.  Needs doctest package
#  http://octave.sourceforge.net/doctest/index.html
doctest: all
	$(OCTAVE) --path "$(TOPDIR)/inst" --path "$(TOPDIR)/src" \
	  --eval '${PKG_ADD}' \
	  --eval 'pkg load doctest;' \
	  --eval "targets = {'$(TOPDIR)/inst', '$(TOPDIR)/src'};" \
	  --eval "doctest (targets);"

# Note "doctest" as prerequesite.  When testing the package, also check
# the documentation.
check: all
	$(OCTAVE) --silent --path "$(TOPDIR)/inst/" --path "$(TOPDIR)/src/" \
	  --eval 'if(!isempty("$(DEPENDS)")); pkg load $(DEPENDS); endif;' \
	  --eval '${PKG_ADD}' \
	  --eval "__run_test_suite__ ({'$(TOPDIR)/inst'}, {})"
