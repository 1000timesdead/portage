# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libhash/libhash-1.0.3.ebuild,v 1.2 2010/05/18 18:50:50 flameeyes Exp $

inherit toolchain-funcs

DESCRIPTION="a small hash library written in C"
HOMEPAGE="ftp://ftp.ugh.net.au/pub/unix/libhash/"
SRC_URI="ftp://ftp.ugh.net.au/pub/unix/libhash/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm hppa ia64 ppc x86"
IUSE="doc"

DEPEND=""

S=${WORKDIR}/${PN}

src_compile() {
	rm -f Makefile
	$(tc-getCC) ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} -fPIC -shared -o libhash.so hash.c || die ".so failed"
	$(tc-getCC) ${CPPFLAGS} ${CFLAGS} -c -o libhash.a hash.c || die ".a failed"
}

src_test() {
	cd tests
	sed -i '/wrappers.h/d' *.c
	for n in 2 3 ; do
		$(tc-getCC) ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} -I.. -L.. ${n}.c -o ${n} -lhash || die "compile ${n} failed"
		LD_LIBRARY_PATH=.. ./${n} || die "test ${n} failed"
	done
}

src_install() {
	insinto /usr/include
	doins hash.h || die "hash.h"
	dolib.so libhash.so || die "dolib.so"
	dolib.a libhash.a || die "dolib.a"
	doman *.3 || die "doman"
	use doc && dodoc tests/*.c
}
