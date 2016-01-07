PACKAGE = gnupg
ORG = amylum

BUILD_DIR = /tmp/$(PACKAGE)-build
RELEASE_DIR = /tmp/$(PACKAGE)-release
RELEASE_FILE = /tmp/$(PACKAGE).tar.gz
PATH_FLAGS = --prefix=/usr --infodir=/tmp/trash --libexecdir=/usr/lib/gnupg --sbindir=/usr/bin
CONF_FLAGS = --enable-maintainer-mode
CFLAGS = -static -static-libgcc -Wl,-static -lc

PACKAGE_VERSION = $$(git --git-dir=upstream/.git describe --tags | sed 's/gnupg-//')
PATCH_VERSION = $$(cat version)
VERSION = $(PACKAGE_VERSION)-$(PATCH_VERSION)

LIBGPG-ERROR_VERSION = 1.21-3
LIBGPG-ERROR_URL = https://github.com/amylum/libgpg-error/releases/download/$(LIBGPG-ERROR_VERSION)/libgpg-error.tar.gz
LIBGPG-ERROR_TAR = /tmp/libgpgerror.tar.gz
LIBGPG-ERROR_DIR = /tmp/libgpg-error
LIBGPG-ERROR_PATH = -I$(LIBGPG-ERROR_DIR)/usr/include -L$(LIBGPG-ERROR_DIR)/usr/lib

LIBASSUAN_VERSION = 2.4.2-3
LIBASSUAN_URL = https://github.com/amylum/libassuan/releases/download/$(LIBASSUAN_VERSION)/libassuan.tar.gz
LIBASSUAN_TAR = /tmp/libassuan.tar.gz
LIBASSUAN_DIR = /tmp/libassuan
LIBASSUAN_PATH = -I$(LIBASSUAN_DIR)/usr/include -L$(LIBASSUAN_DIR)/usr/lib

LIBGCRYPT_VERSION = 1.6.4-2
LIBGCRYPT_URL = https://github.com/amylum/libgcrypt/releases/download/$(LIBGCRYPT_VERSION)/libgcrypt.tar.gz
LIBGCRYPT_TAR = /tmp/libgcrypt.tar.gz
LIBGCRYPT_DIR = /tmp/libgcrypt
LIBGCRYPT_PATH = -I$(LIBGCRYPT_DIR)/usr/include -L$(LIBGCRYPT_DIR)/usr/lib

LIBKSBA_VERSION = 1.3.3-3
LIBKSBA_URL = https://github.com/amylum/libksba/releases/download/$(LIBKSBA_VERSION)/libksba.tar.gz
LIBKSBA_TAR = /tmp/libksba.tar.gz
LIBKSBA_DIR = /tmp/libksba
LIBKSBA_PATH = -I$(LIBKSBA_DIR)/usr/include -L$(LIBKSBA_DIR)/usr/lib

NPTH_VERSION = 1.2-1
NPTH_URL = https://github.com/amylum/npth/releases/download/$(NPTH_VERSION)/npth.tar.gz
NPTH_TAR = /tmp/npth.tar.gz
NPTH_DIR = /tmp/npth
NPTH_PATH = -I$(NPTH_DIR)/usr/include -L$(NPTH_DIR)/usr/lib

GNUTLS_VERSION = 3.4.7-3
GNUTLS_URL = https://github.com/amylum/gnutls/releases/download/$(GNUTLS_VERSION)/gnutls.tar.gz
GNUTLS_TAR = /tmp/gnutls.tar.gz
GNUTLS_DIR = /tmp/gnutls
GNUTLS_PATH = -I$(GNUTLS_DIR)/usr/include -L$(GNUTLS_DIR)/usr/lib

GMP_VERSION = 6.1.0-1
GMP_URL = https://github.com/amylum/gmp/releases/download/$(GMP_VERSION)/gmp.tar.gz
GMP_TAR = /tmp/gmp.tar.gz
GMP_DIR = /tmp/gmp
GMP_PATH = -I$(GMP_DIR)/usr/include -L$(GMP_DIR)/usr/lib

NETTLE_VERSION = 3.1.1-2
NETTLE_URL = https://github.com/amylum/nettle/releases/download/$(NETTLE_VERSION)/nettle.tar.gz
NETTLE_TAR = /tmp/nettle.tar.gz
NETTLE_DIR = /tmp/nettle
NETTLE_PATH = -I$(NETTLE_DIR)/usr/include -L$(NETTLE_DIR)/usr/lib

LIBTASN1_VERSION = 4.7-2
LIBTASN1_URL = https://github.com/amylum/libtasn1/releases/download/$(LIBTASN1_VERSION)/libtasn1.tar.gz
LIBTASN1_TAR = /tmp/libtasn1.tar.gz
LIBTASN1_DIR = /tmp/libtasn1
LIBTASN1_PATH = -I$(LIBTASN1_DIR)/usr/include -L$(LIBTASN1_DIR)/usr/lib

P11-KIT_VERSION = 0.23.1-2
P11-KIT_URL = https://github.com/amylum/p11-kit/releases/download/$(P11-KIT_VERSION)/p11-kit.tar.gz
P11-KIT_TAR = /tmp/p11-kit.tar.gz
P11-KIT_DIR = /tmp/p11-kit
P11-KIT_PATH = -I$(P11-KIT_DIR)/usr/include -L$(P11-KIT_DIR)/usr/lib

ZLIB_VERSION = 1.2.8-1
ZLIB_URL = https://github.com/amylum/zlib/releases/download/$(ZLIB_VERSION)/zlib.tar.gz
ZLIB_TAR = /tmp/zlib.tar.gz
ZLIB_DIR = /tmp/zlib
ZLIB_PATH = -I$(ZLIB_DIR)/usr/include -L$(ZLIB_DIR)/usr/lib

SQLITE_VERSION = 3.10.0-2
SQLITE_URL = https://github.com/amylum/sqlite/releases/download/$(SQLITE_VERSION)/sqlite.tar.gz
SQLITE_TAR = /tmp/sqlite.tar.gz
SQLITE_DIR = /tmp/sqlite
SQLITE_PATH = -I$(SQLITE_DIR)/usr/include -L$(SQLITE_DIR)/usr/lib

.PHONY : default submodule build_container deps manual container deps build version push local

default: submodule container

submodule:
	git submodule update --init

manual: submodule build_container
	./meta/launch /bin/bash || true

build_container:
	docker build -t gnupg-pkg meta

container: build_container
	./meta/launch

deps:
	rm -rf $(LIBGPG-ERROR_DIR) $(LIBGPG-ERROR_TAR)
	mkdir $(LIBGPG-ERROR_DIR)
	curl -sLo $(LIBGPG-ERROR_TAR) $(LIBGPG-ERROR_URL)
	tar -x -C $(LIBGPG-ERROR_DIR) -f $(LIBGPG-ERROR_TAR)
	rm -rf $(LIBASSUAN_DIR) $(LIBASSUAN_TAR)
	mkdir $(LIBASSUAN_DIR)
	curl -sLo $(LIBASSUAN_TAR) $(LIBASSUAN_URL)
	tar -x -C $(LIBASSUAN_DIR) -f $(LIBASSUAN_TAR)
	rm -rf $(LIBGCRYPT_DIR) $(LIBGCRYPT_TAR)
	mkdir $(LIBGCRYPT_DIR)
	curl -sLo $(LIBGCRYPT_TAR) $(LIBGCRYPT_URL)
	tar -x -C $(LIBGCRYPT_DIR) -f $(LIBGCRYPT_TAR)
	rm -rf $(LIBKSBA_DIR) $(LIBKSBA_TAR)
	mkdir $(LIBKSBA_DIR)
	curl -sLo $(LIBKSBA_TAR) $(LIBKSBA_URL)
	tar -x -C $(LIBKSBA_DIR) -f $(LIBKSBA_TAR)
	rm -rf $(NPTH_DIR) $(NPTH_TAR)
	mkdir $(NPTH_DIR)
	curl -sLo $(NPTH_TAR) $(NPTH_URL)
	tar -x -C $(NPTH_DIR) -f $(NPTH_TAR)
	rm -rf $(GNUTLS_DIR) $(GNUTLS_TAR)
	mkdir $(GNUTLS_DIR)
	curl -sLo $(GNUTLS_TAR) $(GNUTLS_URL)
	tar -x -C $(GNUTLS_DIR) -f $(GNUTLS_TAR)
	rm -rf $(GMP_DIR) $(GMP_TAR)
	mkdir $(GMP_DIR)
	curl -sLo $(GMP_TAR) $(GMP_URL)
	tar -x -C $(GMP_DIR) -f $(GMP_TAR)
	rm -rf $(NETTLE_DIR) $(NETTLE_TAR)
	mkdir $(NETTLE_DIR)
	curl -sLo $(NETTLE_TAR) $(NETTLE_URL)
	tar -x -C $(NETTLE_DIR) -f $(NETTLE_TAR)
	rm -rf $(LIBTASN1_DIR) $(LIBTASN1_TAR)
	mkdir $(LIBTASN1_DIR)
	curl -sLo $(LIBTASN1_TAR) $(LIBTASN1_URL)
	tar -x -C $(LIBTASN1_DIR) -f $(LIBTASN1_TAR)
	rm -rf $(P11-KIT_DIR) $(P11-KIT_TAR)
	mkdir $(P11-KIT_DIR)
	curl -sLo $(P11-KIT_TAR) $(P11-KIT_URL)
	tar -x -C $(P11-KIT_DIR) -f $(P11-KIT_TAR)
	rm -rf $(ZLIB_DIR) $(ZLIB_TAR)
	mkdir $(ZLIB_DIR)
	curl -sLo $(ZLIB_TAR) $(ZLIB_URL)
	tar -x -C $(ZLIB_DIR) -f $(ZLIB_TAR)
	rm -rf $(SQLITE_DIR) $(SQLITE_TAR)
	mkdir $(SQLITE_DIR)
	curl -sLo $(SQLITE_TAR) $(SQLITE_URL)
	tar -x -C $(SQLITE_DIR) -f $(SQLITE_TAR)

build: submodule deps
	rm -rf $(BUILD_DIR)
	cp -R upstream $(BUILD_DIR)
	patch -d $(BUILD_DIR) -p0 < patches/remove-strconcat.patch
	cd $(BUILD_DIR) && ./autogen.sh
	cd $(BUILD_DIR) && CC=musl-gcc LIBS='-ltasn1 -lhogweed -lnettle -lp11-kit -lz -lgmp' CFLAGS='$(CFLAGS) $(LIBGPG-ERROR_PATH) $(LIBASSUAN_PATH) $(LIBGCRYPT_PATH) $(LIBKSBA_PATH) $(NPTH_PATH) $(GNUTLS_PATH) $(GMP_PATH) $(NETTLE_PATH) $(LIBTASN1_PATH) $(P11-KIT_PATH) $(ZLIB_PATH) $(SQLITE_PATH)' ./configure $(PATH_FLAGS) $(CONF_FLAGS)
	cd $(BUILD_DIR) && make DESTDIR=$(RELEASE_DIR) install
	ln -s gpg2 $(RELEASE_DIR)/usr/bin/gpg
	rm -rf $(RELEASE_DIR)/tmp
	mkdir -p $(RELEASE_DIR)/usr/share/licenses/$(PACKAGE)
	cp $(BUILD_DIR)/COPYING.LIB $(RELEASE_DIR)/usr/share/licenses/$(PACKAGE)/LICENSE
	cd $(RELEASE_DIR) && tar -czvf $(RELEASE_FILE) *

version:
	@echo $$(($(PATCH_VERSION) + 1)) > version

push: version
	git commit -am "$(VERSION)"
	ssh -oStrictHostKeyChecking=no git@github.com &>/dev/null || true
	git tag -f "$(VERSION)"
	git push --tags origin master
	@sleep 3
	targit -a .github -c -f $(ORG)/$(PACKAGE) $(VERSION) $(RELEASE_FILE)
	@sha512sum $(RELEASE_FILE) | cut -d' ' -f1

local: build push

