# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-opengl/emul-linux-x86-opengl-20110722-r99.ebuild,v 1.1 2011/07/22 19:17:10 pacho Exp $

EAPI="4"

inherit emul-linux-x86

SRC_URI="http://dev.gentoo.org/~pacho/emul/${P}-r99.tar.xz"

LICENSE="BSD LGPL-2 MIT kilgard"

KEYWORDS="-* ~amd64 ~amd64-linux"

DEPEND="app-admin/eselect-opengl
	>=app-admin/eselect-mesa-0.0.9"
RDEPEND=">=app-emulation/emul-linux-x86-xlibs-20100611
	!<app-emulation/emul-linux-x86-xlibs-20100611
	>=app-emulation/emul-linux-x86-baselibs-20110722-r99
	media-libs/mesa"

src_prepare() {
	emul-linux-x86_src_prepare
	rm -f "${S}/usr/lib32/libGL.so" || die
	rm -f "${S}/usr/lib32/libGL.so.1" || die
}

pkg_postinst() {
	# Update GL symlinks
	eselect opengl set --use-old || die
	# And the same for mesa (bug #355393)
	eselect mesa set 32bit --auto || die
}
