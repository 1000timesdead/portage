# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/udpcast/udpcast-20110710.ebuild,v 1.1 2011/07/30 17:05:49 jer Exp $

EAPI=4

DESCRIPTION="Multicast file transfer tool"
HOMEPAGE="http://udpcast.linux.lu/"
SRC_URI="http://udpcast.linux.lu/download/${P}.tar.bz2"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND=""

src_prepare() {
	sed -i Makefile.in \
		-e '/^LDFLAGS +=-s/d' \
		-e '/^CFLAGS/s: -O6::g' \
		|| die
}

src_install() {
	default
	dodoc *.txt
}
