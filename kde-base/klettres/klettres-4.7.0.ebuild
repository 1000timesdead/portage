# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/klettres/klettres-4.7.0.ebuild,v 1.1 2011/07/27 14:04:27 alexxy Exp $

EAPI=4

KDE_HANDBOOK="optional"
KDE_SCM="git"
inherit kde4-base

DESCRIPTION="KDE: KLettres helps a very young child or an adult learning "
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	$(add_kdebase_dep knotify)
"
