# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/gnome-ppp/gnome-ppp-0.3.23-r1.ebuild,v 1.5 2009/03/18 07:33:07 josejx Exp $

inherit gnome2 eutils

MAJOR_V=${PV%.[0-9]*}

DESCRIPTION="A GNOME 2 WvDial frontend"
HOMEPAGE="http://www.gnomefiles.org/app.php?soft_id=41"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=net-dialup/wvdial-1.54
	>=gnome-base/libglade-2.4
	>=x11-libs/gtk+-2.4"
DEPEND="sys-devel/gettext
	dev-util/pkgconfig
	dev-util/intltool
	${RDEPEND}"

USE_DESTDIR="1"
DOCS="ChangeLog"

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}"/${P}-implicit-decl.patch
	epatch "${FILESDIR}"/${P}-wvdial-notify.patch
}

src_install() {
	gnome2_src_install top_builddir="${S}"
}
