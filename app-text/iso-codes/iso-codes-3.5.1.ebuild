# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/iso-codes/iso-codes-3.5.1.ebuild,v 1.1 2009/01/18 21:53:13 eva Exp $

EAPI="2"

inherit eutils autotools

DESCRIPTION="Provides the list of country and language names"
HOMEPAGE="http://alioth.debian.org/projects/pkg-isocodes/"
SRC_URI="ftp://pkg-isocodes.alioth.debian.org/pub/pkg-isocodes/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="sys-devel/gettext
	|| (
		>=dev-lang/python-2.3[-build]
		dev-python/pyxml )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# fix install location for multilib machines
	sed -e 's:(datadir)/pkgconfig:(libdir)/pkgconfig:g' \
		-i Makefile.am || die "sed failed"

	eautomake
}

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"

	dodoc ChangeLog README TODO
}