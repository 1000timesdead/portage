# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/atlas-c++/atlas-c++-0.6.2.ebuild,v 1.3 2010/11/14 22:59:40 hwoarang Exp $
EAPI=2

MY_PN="Atlas-C++"
MY_P=${MY_PN}-${PV}
DESCRIPTION="Atlas protocol, used in role playing games at worldforge."
HOMEPAGE="http://www.worldforge.org/dev/eng/libraries/atlas_cpp"
SRC_URI="mirror://sourceforge/worldforge/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="doc"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${MY_P}

src_compile() {
	emake || die "Error: emake failed!"
	if use doc; then
		emake docs ||  die "Error: emake docs failed!"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	use doc && dohtml -r doc/html/*
	use doc && doman doc/man/*
	dodoc AUTHORS ChangeLog HACKING NEWS README ROADMAP THANKS TODO
}
