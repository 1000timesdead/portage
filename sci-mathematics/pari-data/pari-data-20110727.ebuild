# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/pari-data/pari-data-20110727.ebuild,v 1.1 2011/07/27 19:03:15 bicatali Exp $

EAPI="4"

DESCRIPTION="Data sets for pari"
HOMEPAGE="http://pari.math.u-bordeaux.fr/"

for p in elldata galdata galpol seadata nftables; do
	SRC_URI="${SRC_URI} http://pari.math.u-bordeaux.fr/pub/pari/packages/${p}.tgz -> ${p}-${PV}.tgz"
done

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND=""
S="${WORKDIR}"

src_install() {
	insinto /usr/share/pari
	doins -r data/* nftables
}
