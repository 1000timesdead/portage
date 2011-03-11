# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/filelight/filelight-4.6.1.ebuild,v 1.1 2011/03/04 18:00:00 alexxy Exp $

EAPI=3

KDE_HANDBOOK="optional"
KMNAME="kdeutils"
inherit kde4-meta

DESCRIPTION="Filelight creates an interactive map of concentric, segmented rings that help visualise disk usage."

LICENSE="GPL-3"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug"

RDEPEND="
	!kdeprefix? ( !kde-misc/filelight )
	x11-apps/xdpyinfo
"
