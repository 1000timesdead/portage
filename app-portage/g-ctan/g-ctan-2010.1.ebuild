# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/g-ctan/g-ctan-2010.1.ebuild,v 1.2 2011/06/14 03:32:00 mattst88 Exp $

EAPI=2

DESCRIPTION="Generate and install ebuilds from the TeXLive package manager"
HOMEPAGE="http://launchpad.net/g-ctan"
SRC_URI="http://launchpad.net/g-ctan/2010/${PV}/+download/${P}.tar.bz2"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"

IUSE=""
DEPEND=""
RDEPEND="~app-text/texlive-2010
	app-arch/xz-utils
	>=dev-libs/libpcre-0.7.6"

src_install() {
	emake DESTDIR="${D}" install || die
}
