# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/gutenprint/gutenprint-5.2.7.ebuild,v 1.2 2011/09/11 07:28:19 radhermit Exp $

EAPI=4

inherit eutils multilib autotools

DESCRIPTION="Ghostscript and cups printer drivers"
HOMEPAGE="http://gutenprint.sourceforge.net"
SRC_URI="mirror://sourceforge/gimp-print/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="cups foomaticdb gimp gtk nls readline ppds static-libs"

RDEPEND="app-text/ghostscript-gpl
	dev-lang/perl
	sys-libs/readline
	cups? ( >=net-print/cups-1.1.14 )
	foomaticdb? ( net-print/foomatic-db-engine )
	gimp? ( >=media-gfx/gimp-2.2 x11-libs/gtk+:2 )
	gtk? ( x11-libs/gtk+:2 )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	gtk? ( dev-util/pkgconfig )
	nls? ( sys-devel/gettext )"

RESTRICT="test"

DOCS=( AUTHORS ChangeLog NEWS README doc/gutenprint-users-manual.{pdf,odt} )

src_prepare() {
	epatch "${FILESDIR}/${PN}-5.2.4-CFLAGS.patch"
	sed -i -e "s:m4local:m4extra:" Makefile.am || die
	eautoreconf
}

src_configure() {
	if use cups && use ppds; then
		myconf="${myconf} --enable-cups-ppds --enable-cups-level3-ppds"
	else
		myconf="${myconf} --disable-cups-ppds"
	fi

	if use gtk || use gimp; then
		myconf="${myconf} --enable-libgutenprintui2"
	else
		myconf="${myconf} --disable-libgutenprintui2"
	fi

	use foomaticdb \
		&& myconf="${myconf} --with-foomatic3" \
		|| myconf="${myconf} --without-foomatic"

	econf \
		--enable-test \
		--with-ghostscript \
		--disable-translated-cups-ppds \
		--enable-static-genppd \
		$(use_with gimp gimp2) \
		$(use_with gimp gimp2-as-gutenprint) \
		$(use_with cups) \
		$(use_enable nls) \
		$(use_with readline) \
		$(use_enable static-libs static) \
		${myconf}
}

src_install() {
	default

	dohtml doc/FAQ.html
	dohtml -r doc/gutenprintui2/html
	rm -fR "${D}"/usr/share/gutenprint/doc
	if ! use gtk && ! use gimp; then
		rm -f "${D}"/usr/$(get_libdir)/pkgconfig/gutenprintui2.pc
		rm -rf "${D}"/usr/include/gutenprintui2
	fi

	find "${D}" -name '*.la' -exec rm -f '{}' +
}

pkg_postinst() {
	if [ "${ROOT}" == "/" ] && [ -x /usr/sbin/cups-genppdupdate ]; then
		elog "Updating installed printer ppd files"
		elog $(/usr/sbin/cups-genppdupdate)
	else
		elog "You need to update installed ppds manually using cups-genppdupdate"
	fi
}
