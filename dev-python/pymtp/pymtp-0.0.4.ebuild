# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pymtp/pymtp-0.0.4.ebuild,v 1.5 2010/05/25 21:06:08 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="libmtp bindings for python"
HOMEPAGE="http://nick125.com/projects/pymtp/"
SRC_URI="http://downloads.nick125.com/projects/pymtp/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

RDEPEND=">=media-libs/libmtp-0.2.6"
DEPEND="${RDEPEND}"
RESTRICT_PYTHON_ABIS="3.*"

PYTHON_MODNAME="pymtp.py"
