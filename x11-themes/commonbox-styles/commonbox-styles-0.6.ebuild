# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/commonbox-styles/commonbox-styles-0.6.ebuild,v 1.22 2010/10/17 03:14:38 leio Exp $

IUSE=""
DESCRIPTION="Common styles for fluxbox, blackbox, and openbox."
SRC_URI="mirror://gentoo/${P}.tar.bz2
		http://mkeadle.org/distfiles/${P}.tar.bz2"
HOMEPAGE="http://mkeadle.org/distfiles/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"

RDEPEND="|| ( x11-wm/fluxbox x11-wm/blackbox x11-wm/openbox )"

src_install() {

	insinto /usr/share/commonbox/backgrounds
	doins "${S}"/backgrounds/*

	insinto /usr/share/commonbox/styles
	doins "${S}"/styles/*

	dodoc README.commonbox-styles STYLES.authors

}
