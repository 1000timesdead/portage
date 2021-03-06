# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/sudoku/sudoku-0.7.ebuild,v 1.1 2011/08/05 11:39:24 voyageur Exp $

inherit gnustep-2

MY_PN=${PN/s/S}
S=${WORKDIR}/${MY_PN}-${PV}

DESCRIPTION="Sudoku generator for GNUstep"
HOMEPAGE="http://gap.nongnu.org/sudoku/"
SRC_URI="http://savannah.nongnu.org/download/gap/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
IUSE=""
