# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-keyring/gnome-keyring-2.32.1-r1.ebuild,v 1.1 2011/07/11 11:42:48 pacho Exp $

EAPI="4"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2 multilib pam virtualx

DESCRIPTION="Password and keyring managing daemon"
HOMEPAGE="http://live.gnome.org/GnomeKeyring"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="debug doc pam test"
# USE=valgrind is probably not a good idea for the tree

RDEPEND=">=dev-libs/glib-2.25:2
	>=x11-libs/gtk+-2.20:2
	gnome-base/gconf:2
	>=sys-apps/dbus-1.0
	pam? ( virtual/pam )
	>=dev-libs/libgcrypt-1.2.2
	>=dev-libs/libtasn1-1"
#	valgrind? ( dev-util/valgrind )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1.9 )"
PDEPEND="gnome-base/libgnome-keyring"
# eautoreconf needs:
#	>=dev-util/gtk-doc-am-1.9

# tests fail in several ways, they should be fixed in the next cycle (bug #340283),
# revisit then.
RESTRICT="test"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		$(use_enable debug)
		$(use_enable test tests)
		$(use_enable pam)
		$(use_with pam pam-dir $(getpam_mod_dir))
		--with-root-certs=${EPREFIX}/usr/share/ca-certificates/
		--enable-acl-prompts
		--enable-ssh-agent
		--enable-gpg-agent
		--with-gtk=2.0"
#		$(use_enable valgrind)
}

src_prepare() {
	gnome2_src_prepare

	# Remove silly CFLAGS
	sed 's:CFLAGS="$CFLAGS -Werror:CFLAGS="$CFLAGS:' \
		-i configure.in configure || die "sed failed"

	# Remove DISABLE_DEPRECATED flags
	sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' \
		-i configure.in configure || die "sed 2 failed"

	# Fix undefined type in egg-asn1x.c
	epatch "${FILESDIR}/${PN}-2.32.1-fix-undefined.patch"
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check || die "emake check failed!"
}
