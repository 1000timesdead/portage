# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ogle-gui/ogle-gui-0.9.2.ebuild,v 1.22 2009/06/09 13:30:04 flameeyes Exp $

inherit libtool eutils

IUSE="nls"

MY_P=${P/-/_}
S=${WORKDIR}/${MY_P}
DESCRIPTION="GUI interface for the Ogle DVD player."
HOMEPAGE="http://www.dtek.chalmers.se/groups/dvd/"
SRC_URI="http://www.dtek.chalmers.se/groups/dvd/dist/${MY_P}.tar.gz"

SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc sparc x86 ~x86-fbsd"
LICENSE="GPL-2"

RDEPEND="
	>=media-video/ogle-${PV}
	=x11-libs/gtk+-2*
	=gnome-base/libglade-2*
	dev-libs/libxml2
	nls? ( virtual/libintl )"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	dev-util/pkgconfig
	sys-devel/bison"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}/${P}-text-encoding.patch"
}

src_compile() {

	elibtoolize

	# libxml2 hack
	CFLAGS="${CFLAGS} -I/usr/include/libxml2/libxml"

	# braindead configure does not treat --disable-gtk2 correctly
	econf \
		$(use_enable nls) \
		--enable-gtk2 || die
	emake || die

}

src_install() {
	einstall || die
	dodoc NEWS README
}
