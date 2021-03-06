# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/potrace/potrace-1.10.ebuild,v 1.1 2011/08/19 21:33:14 radhermit Exp $

EAPI="4"

DESCRIPTION="Transforming bitmaps into vector graphics"
HOMEPAGE="http://potrace.sourceforge.net/"
SRC_URI="http://potrace.sourceforge.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="metric"

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		--enable-zlib \
		$(use_enable metric a4) \
		$(use_enable metric)
}
