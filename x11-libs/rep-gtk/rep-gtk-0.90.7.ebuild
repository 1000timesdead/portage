# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/rep-gtk/rep-gtk-0.90.7.ebuild,v 1.1 2011/09/12 14:04:55 pacho Exp $

EAPI="4"

inherit eutils multilib

DESCRIPTION="A GTK+/libglade/GNOME language binding for the librep Lisp environment"
HOMEPAGE="http://rep-gtk.sourceforge.net/"
SRC_URI="http://download.tuxfamily.org/librep/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="gtk-2.0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-libs/librep-0.90.5
	>=dev-libs/glib-2.6:2
	>=x11-libs/gtk+-2.24.0:2"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0"

src_configure() {
	econf \
		--libdir=/usr/$(get_libdir) \
		--disable-static
}

src_install() {
	emake DESTDIR="${D}" install
	find "${D}" -name '*.la' -exec rm -f {} + || die "la file removal failed"
	dodoc AUTHORS ChangeLog README* TODO
}
