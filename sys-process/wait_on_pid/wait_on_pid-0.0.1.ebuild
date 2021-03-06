# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/wait_on_pid/wait_on_pid-0.0.1.ebuild,v 1.5 2011/02/20 15:41:04 xarthisius Exp $

EAPI="2"

DESCRIPTION="small utility to wait for an arbitrary process to exit"
HOMEPAGE="http://dev.gentoo.org/~zzam/wait_on_pid/"
SRC_URI="mirror://gentoo/$P.tar.bz2 http://dev.gentoo.org/~zzam/wait_on_pid/$P.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="!<=media-tv/gentoo-vdr-scripts-0.4.6"
RDEPEND=""

src_install() {
	dobin wait_on_pid || die
	dodoc README
}
