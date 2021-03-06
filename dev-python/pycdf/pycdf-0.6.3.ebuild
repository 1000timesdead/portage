# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pycdf/pycdf-0.6.3.ebuild,v 1.2 2010/07/23 22:22:52 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

MY_P="${PN}-${PV:0:3}-${PV:4:1}"

DESCRIPTION="Python interface to scientific netCDF library."
HOMEPAGE="http://pysclint.sourceforge.net/pycdf/"
SRC_URI="mirror://sourceforge/pysclint/${MY_P}.tar.gz"

LICENSE="PYTHON"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE="examples"

DEPEND="dev-python/numpy
	>=sci-libs/netcdf-3.6.1"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	distutils_src_install

	dohtml doc/pycdf.html
	dodoc CHANGES doc/pycdf.txt

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die "doins failed"
	fi
}
