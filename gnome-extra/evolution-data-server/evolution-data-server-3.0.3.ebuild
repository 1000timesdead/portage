# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/evolution-data-server/evolution-data-server-3.0.3.ebuild,v 1.2 2011/09/02 08:21:52 nirbheek Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit db-use eutils flag-o-matic gnome2 versionator virtualx

DESCRIPTION="Evolution groupware backend"
HOMEPAGE="http://www.gnome.org/projects/evolution/"

LICENSE="LGPL-2 BSD DB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-solaris"
IUSE="doc +introspection ipv6 ldap kerberos ssl +weather"

# GNOME3: How do we slot libedataserverui-3.0.so?
# Also, libedata-cal-1.2.so and libecal-1.2.so use gtk-3, but aren't slotted
RDEPEND=">=dev-libs/glib-2.28:2
	>=x11-libs/gtk+-3.0:3
	>=gnome-base/gconf-2
	>=dev-db/sqlite-3.5
	>=dev-libs/libgdata-0.7.0
	>=gnome-base/gnome-keyring-2.20.1
	>=dev-libs/libical-0.43
	>=net-libs/libsoup-2.31.2:2.4
	>=dev-libs/libxml2-2
	>=sys-libs/db-4
	sys-libs/zlib
	virtual/libiconv
	introspection? ( >=dev-libs/gobject-introspection-0.9.12 )
	kerberos? ( virtual/krb5 )
	ldap? ( >=net-nds/openldap-2 )
	ssl? (
		>=dev-libs/nspr-4.4
		>=dev-libs/nss-3.9 )
	weather? ( >=dev-libs/libgweather-2.90.0:2 )
"
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-util/gperf
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35.5
	sys-devel/bison
	>=gnome-base/gnome-common-2
	>=dev-util/gtk-doc-am-1.9
	>=sys-devel/gettext-0.17
	doc? ( >=dev-util/gtk-doc-1.9 )"
# eautoreconf needs:
#	>=gnome-base/gnome-common-2
#	>=dev-util/gtk-doc-am-1.9

# FIXME
RESTRIC="test"

pkg_setup() {
	DOCS="ChangeLog MAINTAINERS NEWS TODO"
	# Uh, what to do about dbus-call-timeout ?
	G2CONF="${G2CONF}
		$(use_enable ipv6)
		$(use_with kerberos krb5 /usr)
		$(use_with ldap openldap)
		$(use_enable ssl ssl)
		$(use_enable ssl smime)
		$(use_enable weather)
		--enable-calendar
		--enable-nntp
		--enable-largefile
		--with-libdb=/usr"
}

src_prepare() {
	gnome2_src_prepare

	# Adjust to gentoo's /etc/service
	epatch "${FILESDIR}/${PN}-2.31-gentoo_etc_services.patch"

	# GNOME bug 611353 (skips failing test atm)
	# XXX: uncomment when there's a proper fix
	#epatch "${FILESDIR}/e-d-s-camel-skip-failing-test.patch"

	# GNOME bug 621763 (skip failing test-ebook-stress-factory--fifo)
	#sed -e 's/\(SUBDIRS =.*\)ebook/\1/' \
	#	-i addressbook/tests/Makefile.{am,in} \
	#	|| die "failing test sed 1 failed"

	# /usr/include/db.h is always db-1 on FreeBSD
	# so include the right dir in CPPFLAGS
	append-cppflags "-I$(db_includedir)"

	# FIXME: Fix compilation flags crazyness
	# Touch configure.ac if doing eautoreconf
	sed 's/^\(AM_CPPFLAGS="\)$WARNING_FLAGS/\1/' \
		-i configure || die "sed failed"
}

src_install() {
	# Prevent this evolution-data-server from linking to libs in the installed
	# evolution-data-server libraries by adding -L arguments for build dirs to
	# every .la file's relink_command field, forcing libtool to look there
	# first during relinking. This will mangle the .la files installed by
	# make install, but we don't care because we will be punting them anyway.
	perl "${FILESDIR}/fix_relink_command.pl" . ||
		die "fix_relink_command.pl failed"
	gnome2_src_install

	if use ldap; then
		MY_MAJORV=$(get_version_component_range 1-2)
		insinto /etc/openldap/schema
		doins "${FILESDIR}"/calentry.schema || die "doins failed"
		dosym /usr/share/${PN}-${MY_MAJORV}/evolutionperson.schema /etc/openldap/schema/evolutionperson.schema
	fi
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	unset ORBIT_SOCKETDIR
	unset SESSION_MANAGER
	export XDG_DATA_HOME="${T}"
	unset DISPLAY
	Xemake check || die "Tests failed."
}

pkg_postinst() {
	gnome2_pkg_postinst

	if use ldap; then
		elog ""
		elog "LDAP schemas needed by evolution are installed in /etc/openldap/schema"
	fi
}
