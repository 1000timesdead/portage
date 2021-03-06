# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/vhba/vhba-20101015-r1.ebuild,v 1.2 2011/04/28 19:01:45 ulm Exp $

# Use svn snapshots:
# https://sourceforge.net/tracker/?func=detail&atid=603423&aid=3041832&group_id=93175
# "As for the release, could you package the SVN version instead? I'd prefer
# if people used latest SVN at any time anyway..." -- Upstream

EAPI="2"

inherit linux-mod eutils

MY_P=vhba-module-${PV}
DESCRIPTION="VHBA module provides Virtual (SCSI) Host Bus Adapter for the cdemu suite"
HOMEPAGE="http://cdemu.org"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/linux-sources"
RDEPEND=""

S=${WORKDIR}/${MY_P}
MODULE_NAMES="vhba(block:${S})"
BUILD_TARGETS=all

pkg_setup() {
	CONFIG_CHECK="~BLK_DEV_SR ~CHR_DEV_SG"
	check_extra_config
	BUILD_PARAMS="KDIR=${KV_DIR}"
	linux-mod_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-scsi-host-lock-push-down.patch
}

src_install() {
	linux-mod_src_install || die "Error: installing module failed!"

	einfo "Generating udev rules ..."
	dodir /etc/udev/rules.d/
	cat > "${D}"/etc/udev/rules.d/70-vhba.rules <<-EOF || die
	# do not edit this file, it will be overwritten on update
	#
	KERNEL=="vhba_ctl", MODE="0660", OWNER="root", GROUP="cdemu"
	EOF
}

pkg_postinst() {
	enewgroup cdemu

	elog "Don't forget to add your user to the cdemu group"
	elog "if you want to be able to use virtual cdemu devices."
	linux-mod_pkg_postinst
}
