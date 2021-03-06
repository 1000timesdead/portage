# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libctl/libctl-3.1.ebuild,v 1.4 2011/06/21 15:13:09 jlec Exp $

EAPI=4

inherit fortran-2

DESCRIPTION="Guile-based library for scientific simulations"
HOMEPAGE="http://ab-initio.mit.edu/libctl/"
SRC_URI="http://ab-initio.mit.edu/libctl/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples"

DEPEND="
	virtual/fortran

	>=dev-scheme/guile-1.6[deprecated]
	sci-libs/nlopt"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--enable-shared \
		$(use_enable debug)
}

src_install() {
	default
	if use doc; then
		dohtml doc/*
	fi
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		cd examples
		doins Makefile.am README *.c *.h *.ctl *scm
	fi
}
