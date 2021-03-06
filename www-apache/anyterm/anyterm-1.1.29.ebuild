# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/anyterm/anyterm-1.1.29.ebuild,v 1.2 2009/12/12 03:54:34 arfrever Exp $

EAPI="2"

inherit eutils flag-o-matic

DESCRIPTION="A terminal anywhere."
HOMEPAGE="http://anyterm.org/"
SRC_URI="http://anyterm.org/download/${P}.tbz2"

LICENSE="GPL-2 Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/ssh"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.34.1"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.1.28-respect-LDFLAGS.patch"
	epatch "${FILESDIR}/${P}-gcc-4.4.patch"
}

src_compile() {
	# this package uses `ld -r -b binary` and thus resulting executalbe contains
	# executable stack
	append-ldflags -Wl,-z,noexecstack
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" || die
}

src_install() {
	dosbin anytermd || die
	dodoc CHANGELOG README || die
	doman anytermd.1 || die
	newinitd "${FILESDIR}/anyterm.init.d" anyterm || die
	newconfd "${FILESDIR}/anyterm.conf.d" anyterm || die
}

pkg_postinst() {
	elog "To proceed installation, read following:"
	elog "http://anyterm.org/1.1/install.html"
}
