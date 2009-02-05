# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libburn/libburn-0.6.0_p01.ebuild,v 1.1 2009/02/01 02:35:31 loki_val Exp $

EAPI=2

MY_PL=00
[[ ${PV/_p} != ${PV} ]] && MY_PL=${PV#*_p}
MY_PV="${PV%_p*}.pl${MY_PL}"

DESCRIPTION="Libburn is an open-source library for reading, mastering and writing optical discs."
HOMEPAGE="http://libburnia-project.org"
SRC_URI="http://files.libburnia-project.org/releases/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="dev-util/pkgconfig"

S=${WORKDIR}/${P%_p*}

src_configure() {
	econf --disable-static
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS CONTRIBUTORS README doc/comments
	find "${D}" -name '*.la' -exec rm -rf '{}' '+' || die "la removal failed"
}