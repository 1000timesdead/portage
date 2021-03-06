# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gcalctool/gcalctool-6.0.2.ebuild,v 1.1 2011/08/19 11:20:17 nirbheek Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2

DESCRIPTION="A calculator application for GNOME"
HOMEPAGE="http://live.gnome.org/Gcalctool http://calctool.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"

COMMON_DEPEND=">=x11-libs/gtk+-2.90.7:3
	>=dev-libs/glib-2.25.10:2
	dev-libs/libxml2"
DEPEND="${COMMON_DEPEND}
	>=app-text/gnome-doc-utils-0.3.2
	app-text/scrollkeeper
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	virtual/yacc
	sys-devel/flex
	sys-devel/gettext"
RDEPEND="${COMMON_DEPEND}
	!<gnome-extra/gnome-utils-2.3"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-maintainer-mode
		--disable-schemas-compile
		--with-gtk=3.0"
	DOCS="AUTHORS ChangeLog* NEWS README"
}
