# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/cclive/cclive-0.7.4.ebuild,v 1.1 2011/06/22 14:22:22 aballier Exp $

EAPI=4

inherit base

DESCRIPTION="Command line tool for extracting videos from various websites"
HOMEPAGE="http://cclive.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PV:0:3}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=media-libs/quvi-0.2.17
	>=dev-libs/boost-1.42
	>=net-misc/curl-7.20
	>=dev-libs/libpcre-8.02[cxx]"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	app-arch/xz-utils"

# It fails to build without an out-of-tree build
S="${WORKDIR}/${P}_build"
SRCDIR="${WORKDIR}/${P}"
ECONF_SOURCE="${SRCDIR}"

DOCS=(
		"${SRCDIR}/ChangeLog"
		"${SRCDIR}/NEWS"
		"${SRCDIR}/README"
	)

src_unpack() {
	mkdir "${S}"
	unpack ${A}
}
