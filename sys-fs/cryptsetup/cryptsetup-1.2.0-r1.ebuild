# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/cryptsetup/cryptsetup-1.2.0-r1.ebuild,v 1.8 2011/09/07 04:02:54 vapier Exp $

EAPI="2"

inherit linux-info eutils multilib libtool

MY_P=${P/_rc/-rc}
DESCRIPTION="Tool to setup encrypted devices with dm-crypt"
HOMEPAGE="http://code.google.com/p/cryptsetup/"
SRC_URI="http://cryptsetup.googlecode.com/files/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="+static nls selinux"

S=${WORKDIR}/${MY_P}

RDEPEND=">=sys-fs/lvm2-2.02.64
	>=dev-libs/libgcrypt-1.1.42
	!static? (
		dev-libs/libgpg-error
		>=dev-libs/popt-1.7
		>=sys-apps/util-linux-2.17.2
	)
	>=sys-fs/udev-124
	|| ( >=sys-libs/e2fsprogs-libs-1.41 <sys-fs/e2fsprogs-1.41 )
	selinux? ( sys-libs/libselinux )
	!sys-fs/cryptsetup-luks"
DEPEND="${RDEPEND}
	static? (
		>=dev-libs/libgpg-error-1.10[static-libs]
		>=dev-libs/popt-1.16-r1[static-libs]
		|| ( >=sys-apps/util-linux-2.20[static-libs] <sys-apps/util-linux-2.20 )
		dev-libs/libgcrypt[static-libs]
	)"

pkg_setup() {
	local CONFIG_CHECK="~DM_CRYPT ~CRYPTO ~CRYPTO_CBC"
	local WARNING_DM_CRYPT="CONFIG_DM_CRYPT:\tis not set (required for cryptsetup)\n"
	local WARNING_CRYPTO_CBC="CONFIG_CRYPTO_CBC:\tis not set (required for kernel 2.6.19)\n"
	local WARNING_CRYPTO="CONFIG_CRYPTO:\tis not set (required for cryptsetup)\n"
	check_extra_config
}

src_prepare() {
	sed -i '/enable_static_cryptsetup=yes/d' configure #350463
	sed -i '/^LOOPDEV=/s:=.*:=`losetup -f` || exit 0:' tests/{compat,mode}-test
	elibtoolize
}

src_configure() {
	econf \
		--sbindir=/sbin \
		--enable-shared \
		--libdir=/usr/$(get_libdir) \
		$(use_enable static static-cryptsetup) \
		$(use_enable nls) \
		$(use_enable selinux)
}

src_test() {
	if [[ ! -e /dev/mapper/control ]] ; then
		ewarn "No /dev/mapper/control found -- skipping tests"
		return 0
	fi
	default
}

src_install() {
	emake DESTDIR="${D}" install || die
	use static && { mv "${D}"/sbin/cryptsetup{.static,} || die ; }
	dodoc TODO ChangeLog README NEWS

	insinto /$(get_libdir)/rcscripts/addons
	newins "${FILESDIR}"/1.1.3-dm-crypt-start.sh dm-crypt-start.sh || die
	newins "${FILESDIR}"/1.1.3-dm-crypt-stop.sh dm-crypt-stop.sh || die
	newconfd "${FILESDIR}"/1.0.6-dmcrypt.confd dmcrypt || die
	newinitd "${FILESDIR}"/1.0.5-dmcrypt.rc dmcrypt || die
}

pkg_postinst() {
	ewarn "This ebuild introduces a new set of scripts and configuration"
	ewarn "than the last version. If you are currently using /etc/conf.d/cryptfs"
	ewarn "then you *MUST* copy your old file to:"
	ewarn "/etc/conf.d/dmcrypt"
	ewarn "Or your encrypted partitions will *NOT* work."
	elog "Please see the example for configuring a LUKS mountpoint"
	elog "in /etc/conf.d/dmcrypt"
	elog
	elog "If you are using baselayout-2 then please do:"
	elog "rc-update add dmcrypt boot"
	elog "This version introduces a command line arguement 'key_timeout'."
	elog "If you want the search for the removable key device to timeout"
	elog "after 10 seconds add the following to your bootloader config:"
	elog "key_timeout=10"
	elog "A timeout of 0 will mean it will wait indefinitely."
	elog
	elog "Users using cryptsetup-1.0.x (dm-crypt plain) volumes must use"
	elog "a compatibility mode when using cryptsetup-1.1.x. This can be"
	elog "done by specifying the cipher (-c), key size (-s) and hash (-h)."
	elog "For more info, see http://code.google.com/p/cryptsetup/wiki/FrequentlyAskedQuestions#6._Issues_with_Specific_Versions_of_cryptsetup"
}
