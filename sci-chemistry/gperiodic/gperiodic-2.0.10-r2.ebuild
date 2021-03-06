# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/gperiodic/gperiodic-2.0.10-r2.ebuild,v 1.1 2010/08/23 19:48:31 xarthisius Exp $

EAPI="2"

inherit toolchain-funcs eutils

DESCRIPTION="Periodic table application for Linux"
SRC_URI="http://www.frantz.fi/software/${P}.tar.gz"
HOMEPAGE="http://www.frantz.fi/software/gperiodic.php"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="nls"

RDEPEND=">=sys-libs/ncurses-5.2
	x11-libs/gtk+:2
	x11-libs/cairo[X]
	nls? ( sys-devel/gettext )"

DEPEND="${RDEPEND}
		dev-util/pkgconfig"

src_prepare() {
	use nls && myopts="enable_nls=1" || myopts="enable_nls=0"
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {
	emake CC=$(tc-getCC) ${myopts} || die
}

src_install() {
	emake DESTDIR="${D}" ${myopts} install || die
	dodoc AUTHORS ChangeLog README NEWS || die
}
