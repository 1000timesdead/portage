# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pylibpcap/pylibpcap-0.6.2.ebuild,v 1.2 2010/12/30 21:37:15 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="Python interface to libpcap"
HOMEPAGE="http://sourceforge.net/projects/pylibpcap/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~x86"
IUSE="examples"

RDEPEND="virtual/libpcap"
DEPEND="${RDEPEND}
	>=dev-lang/swig-1.3.34"

PYTHON_MODNAME="pcap.py"

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die "Installation of examples failed"
	fi
}
