# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/dina/dina-2.89.ebuild,v 1.2 2009/09/21 21:57:27 maekke Exp $

inherit font

DESCRIPTION="A monospace bitmap font, primarily aimed at programmers"
HOMEPAGE="http://www.donationcoder.com/Software/Jibz/Dina/index.html"
SRC_URI="http://omploader.org/vMjIwNA/dina-pcf-${PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S=${WORKDIR}/Dina-PCF
FONT_S=${WORKDIR}/Dina-PCF
FONT_SUFFIX="pcf"
