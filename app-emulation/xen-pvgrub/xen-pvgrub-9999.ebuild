# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/xen-pvgrub/xen-pvgrub-9999.ebuild,v 1.3 2011/08/09 17:35:54 alexxy Exp $

EAPI="2"

inherit flag-o-matic eutils multilib mercurial git

DESCRIPTION="allows to boot Xen domU kernels from a menu.lst laying inside guest filesystem"
HOMEPAGE="http://xen.org/"
SRC_URI="
		http://alpha.gnu.org/gnu/grub/grub-0.97.tar.gz
		http://downloads.sourceforge.net/project/libpng/zlib/1.2.3/zlib-1.2.3.tar.gz
		http://www.kernel.org/pub/software/utils/pciutils/pciutils-2.2.9.tar.bz2
		http://download.savannah.gnu.org/releases/lwip/lwip-1.3.0.tar.gz
		ftp://sources.redhat.com/pub/newlib/newlib-1.16.0.tar.gz
		"

MERC_REPO="xen-unstable.hg"
GIT_REPO="qemu-xen-unstable.git"

EHG_REPO_URI="http://xenbits.xensource.com/${MERC_REPO}"
EGIT_REPO_URI="git://xenbits.xensource.com/${GIT_REPO}"
EGIT_PROJECT="${GIT_REPO}"

S="${WORKDIR}/${MERC_REPO}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="custom-cflags multilib"

DEPEND="sys-devel/gettext
	sys-devel/gcc"

RDEPEND=">=app-emulation/xen-${PV}"

pkg_setup() {
	# use emerge to fetch qemu/ioemu
	export "CONFIG_QEMU=${WORKDIR}/${GIT_REPO}"
}

src_unpack() {
	default_src_unpack

	# unpack xen
	mercurial_src_unpack

	EGIT_COMMIT=$(sed -n -e "s/QEMU_TAG := \(.*\)/\1/p" "${S}"/Config.mk)

	# unpack ioemu repos
	S=${WORKDIR}/${GIT_REPO}
	git_src_unpack

	S=${WORKDIR}/${MERC_REPO}
}

src_prepare() {
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

	sed -i \
	-e 's/WGET=.*/WGET=cp -t . /' \
	-e "s;\$(XEN_EXTFILES_URL);${DISTDIR};" \
	-e 's/$(LD)/$(LD) LDFLAGS=/' \
	-e 's;install-grub: pv-grub;install-grub:;' \
	"${S}"/stubdom/Makefile || die
}

src_compile() {
	use custom-cflags || unset CFLAGS
	if test-flag-CC -fno-strict-overflow; then
		append-flags -fno-strict-overflow
	fi

	emake -C tools/include || die "prepare libelf headers failed"

	if use x86; then
		emake XEN_TARGET_ARCH="x86_32" -C stubdom pv-grub || die "compile pv-grub_x86_32 failed"
	fi
	if use amd64; then
		emake XEN_TARGET_ARCH="x86_64" -C stubdom pv-grub || die "compile pv-grub_x86_64 failed"
		if use multilib; then
			multilib_toolchain_setup x86
			emake XEN_TARGET_ARCH="x86_32" -C stubdom pv-grub || die "compile pv-grub_x86_32 failed"
		fi
	fi
}

src_install() {
	if use x86; then
		emake XEN_TARGET_ARCH="x86_32" DESTDIR="${D}" -C stubdom install-grub || die "install pv-grub_x86_32 failed"
	fi
	if use amd64; then
		emake XEN_TARGET_ARCH="x86_64" DESTDIR="${D}" -C stubdom install-grub || die "install pv-grub_x86_64 failed"
		if use multilib; then
			emake XEN_TARGET_ARCH="x86_32" DESTDIR="${D}" -C stubdom install-grub || die "install pv-grub_x86_32 failed"
		fi
	fi
}

pkg_postinst() {
	elog "Official Xen Guide and the unoffical wiki page:"
	elog " http://www.gentoo.org/doc/en/xen-guide.xml"
	elog " http://en.gentoo-wiki.com/wiki/Xen/"
}
