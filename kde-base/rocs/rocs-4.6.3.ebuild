# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/rocs/rocs-4.6.3.ebuild,v 1.2 2011/06/08 23:45:05 tomka Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kdeedu"
inherit kde4-meta

DESCRIPTION="KDE4 interface to work with Graph Theory"
KEYWORDS="~amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	>=dev-cpp/eigen-2.0.3:2
"
RDEPEND=""
