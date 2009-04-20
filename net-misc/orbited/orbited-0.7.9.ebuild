# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/orbited/orbited-0.7.9.ebuild,v 1.3 2009/04/20 11:28:24 caleb Exp $

inherit distutils

DESCRIPTION="Real-time communication for the browser."
HOMEPAGE="http://orbited.org"
SRC_URI="http://pypi.python.org/packages/source/o/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/twisted
	>=dev-python/morbid-0.8.4
	dev-python/demjson
	dev-python/stomper
	>=dev-python/uuid-1.2"
DEPEND="${RDEPEND}
	dev-python/setuptools"

src_install() {
	distutils_src_install
	insinto /etc
	dosins "${FILESDIR}/${PV}/orbited.cfg" || die "installing config file failed"
	newinitd "${FILESDIR}/${PV}/orbited.init" orbited
}
