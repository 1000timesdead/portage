# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libtommath/libtommath-0.42.0-r1.ebuild,v 1.1 2011/08/02 05:18:40 jer Exp $

EAPI=4

inherit autotools-utils eutils multilib toolchain-funcs

DESCRIPTION="highly optimized and portable routines for integer based number theoretic applications"
HOMEPAGE="http://www.libtom.org/"
SRC_URI="http://www.libtom.org/files/ltm-${PV}.tar.bz2"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc examples static-libs"

DEPEND="sys-devel/libtool"

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch

	[[ ${CHOST} == *-darwin* ]] && \
		sed -i -e 's/libtool/glibtool/g' makefile.shared
}

src_compile() {
	emake CC=$(tc-getCC) -f makefile.shared IGNORE_SPEED=1 LIBPATH="${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	emake -f makefile.shared \
		DESTDIR="${ED}" \
		LIBPATH="${EPREFIX}/usr/$(get_libdir)" \
		INCPATH="${EPREFIX}/usr/include" \
		install

	dodoc changes.txt

	use doc && dodoc *.pdf

	if use examples ; then
		docinto demo
		dodoc demo/*.c
	fi

	use static-libs || remove_libtool_files
}
