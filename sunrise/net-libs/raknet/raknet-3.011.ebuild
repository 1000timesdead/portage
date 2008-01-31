# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="Multiplayer game network engine"
HOMEPAGE="http://www.rakkarsoft.com/"
SRC_URI="mirror://sourceforge/raknetjenkinsso/raknet-${PV}.tar.gz"
LICENSE="CCPL-Attribution-NonCommercial-2.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc autopatcher rakvoice"

RDEPEND="	rakvoice? ( media-libs/speex ) \
			autopatcher? ( dev-db/libpq app-arch/bzip2 )"
DEPEND="	${RDEPEND}
			dev-util/pkgconfig"

src_compile() {
	econf \
		$(use_enable rakvoice) \
		$(use_enable autopatcher) \
	|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc readme.txt
	if use doc; then
		dohtml Help/*
		docinto api_reference
		dohtml Help/Doxygen/html/*
	fi
}
