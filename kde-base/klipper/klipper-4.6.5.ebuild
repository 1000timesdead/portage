# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/klipper/klipper-4.6.5.ebuild,v 1.3 2011/08/15 21:34:22 maekke Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kdebase-workspace"
inherit kde4-meta

DESCRIPTION="Applet for KDE and X clipboard management"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep libkworkspace)
	$(add_kdebase_dep libtaskmanager)
	!aqua? ( x11-libs/libXfixes )
"
RDEPEND="${DEPEND}"
