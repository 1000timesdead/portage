# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/amap/amap-5.2-r2.ebuild,v 1.1 2010/08/15 23:44:20 jer Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="A network scanning tool for pentesters"
HOMEPAGE="http://www.thc.org/thc-amap/"
SRC_URI="http://www.thc.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="ssl"

DEPEND="
	dev-libs/libpcre
	ssl? ( >=dev-libs/openssl-0.9.6j )
"
RDEPEND="
	${DEPEND}
	!sci-biology/amap
"

src_prepare() {
	rm -rf pcre-3.9
	sed -i -e "s:etc/:share/amap/:g" amap-lib.c || die "sed amap-lib.c failed"
	# Above change requires below change. See sources...
	sed -i '/strlen(AMAP_PREFIX/s: 5 : 12 :' amap-lib.c || die "sed amap-lib.c failed"
	sed -i 's:/usr/local:/usr:' amap.h || die "sed amap.h failed"
	# Files to be updated are at different location, bug 207839.
	sed -i '/AMAP_RESOURCE/s:www:freeworld:' amap.h || die "sed amap.h failed"

	sed -i '/DATADIR/s:/etc:/share/amap:' Makefile.am || die "sed Makefile.am failed"

	epatch "${FILESDIR}"/4.8-system-pcre.patch
}

src_configure() {
	# has it's own stupid custom configure script
	./configure || die "configure failed"
	sed -i \
		-e '/^XDEFINES=/s:=.*:=:' \
		-e '/^XLIBS=/s:=.*:=:' \
		-e '/^XLIBPATHS/s:=.*:=:' \
		-e '/^XIPATHS=/s:=.*:=:' \
		-e "/^CC=/d" \
		Makefile || die "pruning vars"
	if use ssl ; then
		sed -i \
			-e '/^XDEFINES=/s:=:=-DOPENSSL:' \
			-e '/^XLIBS=/s:=:=-lcrypto -lssl:' \
			Makefile || die "adding ssl"
	fi
	sed -i Makefile \
		-e '/-o amap/{s|(OPT) |(OPT) $(LDFLAGS) |g}' \
		|| die "respecting LDFLAGS failed"
}

src_compile() {
	emake CC=$(tc-getCC) OPT="${CFLAGS}" || die "emake failed"
}

src_install() {
	dobin amap amapcrap || die "dobin failed"
	insinto /usr/share/amap
	doins appdefs.* || die "doins failed"

	doman ${PN}.1
	dodoc README TODO CHANGES
}
