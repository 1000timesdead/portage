# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyasn1/pyasn1-0.0.13b.ebuild,v 1.7 2011/05/28 11:51:59 ranger Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="ASN.1 library for Python"
HOMEPAGE="http://pyasn1.sourceforge.net/ http://pypi.python.org/pypi/pyasn1"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ppc ppc64 ~s390 ~sh ~sparc x86"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND=""

DOCS="CHANGES README THANKS TODO"

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test/suite.py
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	dohtml doc/* || die "dohtml failed"
}

pkg_postinst() {
	distutils_pkg_postinst

	elog
	elog "ASN.1 modules have been split to dev-python/pyasn1-modules package."
	elog
}
