# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kwrite/kwrite-4.7.1.ebuild,v 1.1 2011/09/07 20:14:05 alexxy Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kate"
KDE_SCM="git"
inherit kde4-meta

DESCRIPTION="KDE MDI editor/IDE"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	$(add_kdebase_dep katepart)
"
