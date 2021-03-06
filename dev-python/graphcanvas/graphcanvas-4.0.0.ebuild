# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/graphcanvas/graphcanvas-4.0.0.ebuild,v 1.1 2011/08/03 23:54:52 bicatali Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils virtualx

DESCRIPTION="Enthought Tool Suite: Interactive Graph (network) Visualization"
HOMEPAGE="http://pypi.python.org/pypi/graphcanvas"
SRC_URI="http://www.enthought.com/repo/ets/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

RDEPEND="dev-python/networkx
	dev-python/enable"
DEPEND="dev-python/setuptools
	test? (
		${RDEPEND}
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
		x11-apps/xhost
	)"

src_test() {
	VIRTUALX_COMMAND="distutils_src_test" virtualmake
}

src_install() {
	find -name "*LICENSE*.txt" -delete
	distutils_src_install

	if use doc; then
		pushd docs/build/html > /dev/null
		insinto /usr/share/doc/${PF}/html
		doins -r [a-z]* _static || die "Installation of documentation failed"
		popd > /dev/null
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die "Installation of examples failed"
	fi
}
