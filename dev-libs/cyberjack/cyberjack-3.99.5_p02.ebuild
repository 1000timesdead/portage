# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cyberjack/cyberjack-3.99.5_p02.ebuild,v 1.1 2011/08/05 19:08:23 ssuominen Exp $

EAPI=4
inherit toolchain-funcs

MY_P=pcsc-${PN}_${PV/_p/final.SP}

DESCRIPTION="REINER SCT cyberJack pinpad/e-com USB user space driver library"
HOMEPAGE="http://www.reiner-sct.de/ http://www.libchipcard.de/"
SRC_URI="http://support.reiner-sct.de/downloads/LINUX/V${PV/_p/_SP}/${MY_P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fox xml"

RDEPEND="sys-apps/pcsc-lite
	virtual/libusb:1
	fox? ( >=x11-libs/fox-1.6 )
	xml? ( dev-libs/libxml2 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P/_/-}

DOCS=( ChangeLog NEWS doc/README.txt )

src_configure() {
	econf \
		--mandir=/usr/share/man/man8 \
		--sysconfdir=/etc/${PN} \
		--disable-hal \
		--enable-pcsc \
		$(use_enable xml xml2) \
		$(use_enable fox) \
		--with-usbdropdir="$($(tc-getPKG_CONFIG) libpcsclite --variable=usbdropdir)"
}

src_install() {
	default

# FIXME: Should we install udev rules (from 3.3.5-r2) and do they need updating?
#	insinto /lib/udev
#	doins "${FILESDIR}"/cyberjack.sh
#	insinto /lib/udev/rules.d
#	newins "${FILESDIR}"/cyberjack.rules-r1 99-cyberjack-rules

	rm -f "${D}"usr/lib*/cyberjack/pcscd_init.diff
	find "${D}"usr -name '*.la' -exec rm -f {} +
}

pkg_postinst() {
	local conf="${ROOT}etc/${PN}/${PN}.conf"
	elog
	elog "To configure logging, key beep behaviour etc. you need to"
	elog "copy ${conf}.default"
	elog "to ${conf}"
	elog "and modify the latter as needed."
	elog
}
