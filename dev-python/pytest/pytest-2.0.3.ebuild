# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pytest/pytest-2.0.3.ebuild,v 1.6 2011/07/24 16:29:38 xarthisius Exp $

EAPI="3"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="py.test: simple powerful testing with Python"
HOMEPAGE="http://pytest.org/ http://pypi.python.org/pypi/pytest"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND=">=dev-python/py-1.4.3"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-python/setuptools"

DOCS="CHANGELOG README.txt"
PYTHON_MODNAME="pytest.py _pytest"

src_prepare() {
	distutils_src_prepare

	# Disable versioning of py.test script to avoid collision with versioning performed by distutils_src_install().
	sed -e "s/return points/return {'py.test': target}/" -i setup.py || die "sed failed"
}

src_test() {
	testing() {
		PYTHONPATH="${S}/build-${PYTHON_ABI}/lib" "$(PYTHON)" "build-${PYTHON_ABI}/lib/pytest.py"
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	python_generate_wrapper_scripts -E -f -q "${ED}usr/bin/py.test"
}
