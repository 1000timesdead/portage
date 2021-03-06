# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/touchcal/touchcal-0.31-r1.ebuild,v 1.1 2011/04/14 06:56:52 jlec Exp $

EAPI="4"

inherit eutils

DESCRIPTION="Touchscreen calibration utility"
HOMEPAGE="http://touchcal.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-buff-overflow.patch
}
