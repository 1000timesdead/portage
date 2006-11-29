# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt4

DESCRIPTION="BitTorrent client in C++ and Qt."
HOMEPAGE="http://www.qbittorrent.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=net-libs/rb_libtorrent-0.11
	$(qt4_min_version 4.1)
	>=dev-lang/python-2.3
	dev-libs/boost
	net-misc/curl"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ! built_with_use dev-libs/boost threads; then
		eerror "dev-libs/boost has to be built with threads USE-flag."
		die "Missing threads USE-flag for dev-libs/boost"
	fi
}

src_compile() {
	# econf fails, since this uses qconf
	./configure --prefix=/usr --qtdir=/usr || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc AUTHORS Changelog NEWS README TODO
}
