# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebase-desktoptheme/kdebase-desktoptheme-4.7.0.ebuild,v 1.1 2011/07/27 14:04:50 alexxy Exp $

EAPI=4

KMNAME="kde-runtime"
KMMODULE="desktoptheme"
inherit kde4-meta

DESCRIPTION="Oxygen KDE4 desktop theme."
IUSE=""
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"

RDEPEND="
	!<=kde-misc/knetworkmanager-4.4.0_p20100820
"
