# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/hotot/hotot-0.9.6_p20110703-r1.ebuild,v 1.1 2011/07/26 16:37:45 xmw Exp $

EAPI=2

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.*"

inherit distutils python

DESCRIPTION="lightweight & open source microblogging client"
HOMEPAGE="http://hotot.org"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/keybinder[python]
	dev-python/notify-python
	dev-python/python-distutils-extra
	>=dev-python/pywebkitgtk-1.1.8"
DEPEND="${RDEPEND}"
