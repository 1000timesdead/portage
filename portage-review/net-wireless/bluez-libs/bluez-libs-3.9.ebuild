# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/bluez-libs/bluez-libs-2.25.ebuild,v 1.4 2006/07/06 06:29:52 corsair Exp $

inherit multilib

DESCRIPTION="Bluetooth Userspace Libraries"
HOMEPAGE="http://bluez.sourceforge.net/"
SRC_URI="http://bluez.sourceforge.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="debug"
DEPEND="!net-wireless/bluez-sdp"
RDEPEND="${DEPEND}"

src_compile() {
	econf $(use_enable debug) || die "econf failed"
	if use debug ; then
		echo "#define SDP_DEBUG 1" >> config.h
	fi
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README

	# http://article.gmane.org/gmane.linux.bluez.announce/57
	# Although library major number changed, API is compatible.
	ln -s libbluetooth.so.2 ${D}/usr/$(get_libdir)/libbluetooth.so.1
}

