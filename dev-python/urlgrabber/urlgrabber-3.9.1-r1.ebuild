# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/urlgrabber/urlgrabber-3.9.1-r1.ebuild,v 1.2 2011/04/06 18:10:18 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.* *-jython"

inherit distutils eutils

DESCRIPTION="Python module for downloading files"
HOMEPAGE="http://urlgrabber.baseurl.org"
SRC_URI="http://urlgrabber.baseurl.org/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-python/pycurl"
RDEPEND="${DEPEND}"
RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}"/${P}.patch
}
