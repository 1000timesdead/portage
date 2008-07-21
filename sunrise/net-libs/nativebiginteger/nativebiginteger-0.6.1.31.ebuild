# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic multilib toolchain-funcs java-pkg-2

DESCRIPTION="NativeBigInteger libs for Freenet taken from i2p"
HOMEPAGE="http://www.i2p.net"
SRC_URI="http://dev.gentooexperimental.org/~tommy/${P}.tar.bz2"

LICENSE="|| ( public-domain BSD MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/gmp
	>=virtual/jdk-1.4
	!net-p2p/nativebiginteger"
RDEPEND="dev-libs/gmp"

QA_TEXTRELS="opt/freenet/lib/libjcpuid-x86-linux.so"

src_compile() {
	append-flags -fPIC
	tc-export CC
	cp "${FILESDIR}"/Makefile .

	make libjbigi || die
	make libjcpuid || die
}

src_install() {
	make DESTDIR="${D}" LIBDIR=$(get_libdir) install || die
}
