# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/hachoir-urwid/hachoir-urwid-1.1.ebuild,v 1.2 2010/12/26 14:34:21 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
PYTHON_USE_WITH="ncurses"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Binary file explorer using Hachoir and urwid libraries"
HOMEPAGE="http://bitbucket.org/haypo/hachoir/wiki/hachoir-urwid http://pypi.python.org/pypi/hachoir-urwid"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/hachoir-core-1.2
	>=dev-python/hachoir-parser-1.0
	>=dev-python/urwid-0.9.4"
DEPEND="${RDEPEND}
	dev-python/setuptools"
RESTRICT_PYTHON_ABIS="3.*"

DISTUTILS_GLOBAL_OPTIONS=("--setuptools")
PYTHON_MODNAME="${PN/-/_}"
