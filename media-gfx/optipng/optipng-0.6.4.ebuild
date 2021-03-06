# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/optipng/optipng-0.6.4.ebuild,v 1.7 2011/01/30 09:23:07 xarthisius Exp $

EAPI=2
inherit toolchain-funcs

DESCRIPTION="Compress PNG files without affecting image quality"
HOMEPAGE="http://optipng.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="alpha amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

DEPEND="media-libs/libpng"

src_prepare() {
	sed -i \
		-e '/^C/s: -O2.*: $(GENTOO_CFLAGS) -Wall:' \
		-e '/^LD/s: -s$: $(GENTOO_LDFLAGS):' \
		src/scripts/gcc.mak.in \
		lib/pngxtern/scripts/gcc.mak.in \
		|| die "sed failed"
	cp lib/libpng/pngpriv.h src/ || die
	rm -rf lib/{libpng,zlib}
}

src_configure() {
	./configure \
		-with-system-libpng \
		-with-system-zlib \
		|| die "configure failed"
}

src_compile() {
	emake \
		-C src \
		-f scripts/gcc.mak \
		CC="$(tc-getCC)" \
		GENTOO_CFLAGS="${CFLAGS}" \
		GENTOO_LDFLAGS="${LDFLAGS}" \
		|| die "emake failed"
}

src_install() {
	dobin src/optipng || die "dobin failed"
	dodoc README.txt doc/*.txt
	dohtml doc/*.html
	doman man/optipng.1
}
