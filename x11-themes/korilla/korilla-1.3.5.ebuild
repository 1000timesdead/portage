# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/korilla/korilla-1.3.5.ebuild,v 1.3 2006/11/28 00:22:23 flameeyes Exp $

DESCRIPTION="Kool Gorilla Icon Set for KDE"
SRC_URI="http://home.comcast.net/~gorillaonkde/gorilla/Korilla_Icons-v${PV}.tar.bz2"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=7264"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE=""
SLOT="0"
LICENSE="GPL-2"

S="${WORKDIR}"

RESTRICT="binchecks strip"

src_install(){
	insinto /usr/share/icons/
	doins -r Kool.Gorilla
}
