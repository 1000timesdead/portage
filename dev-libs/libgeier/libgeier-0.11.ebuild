# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgeier/libgeier-0.11.ebuild,v 1.3 2010/06/21 14:56:42 ssuominen Exp $

DESCRIPTION="Libgeier provides a library to access the german digital tax project ELSTER."
HOMEPAGE="http://www.taxbird.de/"
SRC_URI="http://www.taxbird.de/download/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/xmlsec
	dev-libs/nspr
	dev-libs/nss
	sys-libs/zlib"
DEPEND="${RDEPEND}
	dev-lang/swig"

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README || die
	find "${D}" -name '*.la' -delete
}
