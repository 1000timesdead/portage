# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/xen/xen-4.1.1-r1.ebuild,v 1.1 2011/09/11 14:48:15 alexxy Exp $

EAPI="4"

if [[ $PV == *9999 ]]; then
	KEYWORDS=""
	REPO="xen-unstable.hg"
	EHG_REPO_URI="http://xenbits.xensource.com/${REPO}"
	S="${WORKDIR}/${REPO}"
	live_eclass="mercurial"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="http://bits.xensource.com/oss-xen/release/${PV}/xen-${PV}.tar.gz"
fi

inherit mount-boot flag-o-matic toolchain-funcs ${live_eclass}

DESCRIPTION="The Xen virtual machine monitor"
HOMEPAGE="http://xen.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="custom-cflags debug flask pae xsm"

RDEPEND="|| ( sys-boot/grub
		sys-boot/grub-static )"
PDEPEND="~app-emulation/xen-tools-${PV}"

RESTRICT="test"

# Approved by QA team in bug #144032
QA_WX_LOAD="boot/xen-syms-${PV}"

REQUIRED_USE="
	flask? ( xsm )
	"

pkg_setup() {
	if [[ -z ${XEN_TARGET_ARCH} ]]; then
		if use x86 && use amd64; then
			die "Confusion! Both x86 and amd64 are set in your use flags!"
		elif use x86; then
			export XEN_TARGET_ARCH="x86_32"
		elif use amd64; then
			export XEN_TARGET_ARCH="x86_64"
		else
			die "Unsupported architecture!"
		fi
	fi

	if use flask ; then
		export "XSM_ENABLE=y"
		export "FLASK_ENABLE=y"
	elif use xsm ; then
		export "XSM_ENABLE=y"
	fi
}

src_prepare() {
	# Drop .config
	sed -e '/-include $(XEN_ROOT)\/.config/d' -i Config.mk || die "Couldn't	drop"
	# if the user *really* wants to use their own custom-cflags, let them
	if use custom-cflags; then
		einfo "User wants their own CFLAGS - removing defaults"
		# try and remove all the default custom-cflags
		find "${S}" -name Makefile -o -name Rules.mk -o -name Config.mk -exec sed \
			-e 's/CFLAGS\(.*\)=\(.*\)-O3\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-march=i686\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-fomit-frame-pointer\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-g3*\s\(.*\)/CFLAGS\1=\2 \3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-O2\(.*\)/CFLAGS\1=\2\3/' \
			-i {} \;
	fi
}

src_configure() {
	use debug && myopt="${myopt} debug=y"
	use pae && myopt="${myopt} pae=y"

	if use custom-cflags; then
		filter-flags -fPIE -fstack-protector
		replace-flags -O3 -O2
	else
		unset CFLAGS
	fi
}

src_compile() {
	# Send raw LDFLAGS so that --as-needed works
	emake CC="$(tc-getCC)" LDFLAGS="$(raw-ldflags)" -C xen ${myopt} || die "compile failed"
}

src_install() {
	local myopt
	use debug && myopt="${myopt} debug=y"
	use pae && myopt="${myopt} pae=y"

	emake LDFLAGS="$(raw-ldflags)" DESTDIR="${D}" -C xen ${myopt} install || die "install failed"
}

pkg_postinst() {
	elog "Official Xen Guide and the unoffical wiki page:"
	elog " http://www.gentoo.org/doc/en/xen-guide.xml"
	elog " http://en.gentoo-wiki.com/wiki/Xen/"

	if use pae; then
		echo
		ewarn "This is a PAE build of Xen. It will *only* boot PAE kernels!"
	fi
}
