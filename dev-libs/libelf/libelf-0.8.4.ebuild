# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libelf/libelf-0.8.4.ebuild,v 1.7 2008/06/07 21:31:39 jer Exp $

inherit multilib

DESCRIPTION="A ELF object file access library"
HOMEPAGE="http://www.mr511.de/software/"
SRC_URI="http://www.mr511.de/software/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc sparc x86"
IUSE="nls"

DEPEND="!dev-libs/elfutils
	nls? ( sys-devel/gettext )"

src_compile() {
	econf \
		$(use_enable nls) \
		--enable-shared \
		|| die
	emake || die
}

src_install() {
	make \
		prefix=${D}/usr \
		libdir=${D}usr/$(get_libdir) \
		includedir=${D}usr/include \
		install \
		install-compat || die
	dodoc ChangeLog VERSION README
}
