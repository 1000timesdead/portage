# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/togl/togl-2.0-r1.ebuild,v 1.16 2011/08/15 17:15:10 jlec Exp $

EAPI=2

MY_P="Togl${PV}"

DESCRIPTION="A Tk widget for OpenGL rendering"
HOMEPAGE="http://togl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug +threads"

RDEPEND="
	dev-lang/tk
	virtual/opengl"
DEPEND="${RDEPEND}"

# tests directory is missing
RESTRICT="test"

S="${WORKDIR}"/${MY_P}

src_configure() {
	econf \
		$(use_enable debug symbols) \
		$(use_enable amd64 64bit) \
		$(use_enable threads)
}

src_install() {
	emake DESTDIR="${D}" install || die "failed to install"
	dohtml doc/* || die "no html"
	dodoc README* || die "no README"
}
