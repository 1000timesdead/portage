# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/archfs/archfs-0.5.1.ebuild,v 1.2 2007/10/14 09:39:26 jokey Exp $

DESCRIPTION="Filesystem for rdiff-backup'ed folders"
HOMEPAGE="http://code.google.com/p/archfs"
SRC_URI="http://archfs.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="sys-fs/fuse"
RDEPEND="${DEPEND}
    app-backup/rdiff-backup"

S=${WORKDIR}/${PN}

src_install() {
	emake DESTDIR=${D} install || die "emake install failed"
}
