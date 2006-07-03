# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


DESCRIPTION="Python bindings for libsexy."
HOMEPAGE="http://www.chipx86.com/wiki/Libsexy#sexy-python"
SRC_URI="http://releases.chipx86.com/libsexy/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="~x11-libs/libsexy-${PV}
	>=dev-lang/python-2.3"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README AUTHORS NEWS
}
