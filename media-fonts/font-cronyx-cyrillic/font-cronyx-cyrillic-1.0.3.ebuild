# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/font-cronyx-cyrillic/font-cronyx-cyrillic-1.0.3.ebuild,v 1.5 2010/12/29 21:35:34 maekke Exp $

EAPI=3
inherit xorg-2

DESCRIPTION="X.Org Cronyx cyrillic fonts"

KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	x11-apps/bdftopcf"
