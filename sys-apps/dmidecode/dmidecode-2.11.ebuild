# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/dmidecode/dmidecode-2.11.ebuild,v 1.3 2011/03/23 17:28:30 vapier Exp $

EAPI="2"

inherit flag-o-matic toolchain-funcs

DESCRIPTION="DMI (Desktop Management Interface) table related utilities"
HOMEPAGE="http://www.nongnu.org/dmidecode/"
SRC_URI="http://savannah.nongnu.org/download/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"
IUSE=""

src_prepare() {
	sed -i \
		-e '/^prefix/s:/usr/local:/usr:' \
		-e "/^docdir/s:dmidecode:${PF}:" \
		-e '/^PROGRAMS !=/d' \
		Makefile || die
}

src_compile() {
	emake \
		CFLAGS="${CFLAGS} ${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" \
		|| die
}

src_install() {
	emake install DESTDIR="${D}" || die
	prepalldocs
}
