# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdewebdev-meta/kdewebdev-meta-4.6.3.ebuild,v 1.2 2011/06/08 23:41:41 tomka Exp $

EAPI=4
inherit kde4-meta-pkg

DESCRIPTION="KDE WebDev - merge this to pull in all kdewebdev-derived packages"
KEYWORDS="~amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	$(add_kdebase_dep kfilereplace)
	$(add_kdebase_dep kimagemapeditor)
	$(add_kdebase_dep klinkstatus)
	$(add_kdebase_dep kommander)
"
