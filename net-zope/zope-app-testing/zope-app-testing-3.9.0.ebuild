# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zope-app-testing/zope-app-testing-3.9.0.ebuild,v 1.1 2011/03/26 18:14:42 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils

MY_PN="${PN//-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Zope Application Testing Support"
HOMEPAGE="http://pypi.python.org/pypi/zope.app.testing"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="net-zope/zope-annotation
	net-zope/zope-app-appsetup
	net-zope/zope-app-debug
	net-zope/zope-app-dependable
	net-zope/zope-app-publication
	net-zope/zope-component
	net-zope/zope-container
	net-zope/zope-i18n
	net-zope/zope-interface
	net-zope/zope-password
	net-zope/zope-publisher
	net-zope/zope-schema
	net-zope/zope-security
	net-zope/zope-site
	>=net-zope/zope-testbrowser-4.0.0
	net-zope/zope-testing
	net-zope/zope-traversing"
DEPEND="${RDEPEND}
	dev-python/setuptools"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGES.txt README.txt"
PYTHON_MODNAME="${PN//-//}"
