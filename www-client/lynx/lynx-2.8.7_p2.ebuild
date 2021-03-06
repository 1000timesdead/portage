# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/lynx/lynx-2.8.7_p2.ebuild,v 1.1 2011/03/07 14:00:42 vapier Exp $

EAPI="2"

inherit eutils versionator

# VERSIONING SCHEME TRANSLATION
# Upstream	:	Gentoo
# rel.		:	_p
# pre.		:	_rc
# dev.		:	_pre

case ${PV} in
	*_pre*) MY_P="${PN}${PV/_pre/dev.}" ;;
	*_rc*)  MY_P="${PN}${PV/_rc/pre.}" ;;
	*_p*|*) MY_P="${PN}${PV/_p/rel.}" ;;
esac

DESCRIPTION="An excellent console-based web browser with ssl support"
HOMEPAGE="http://lynx.isc.org/"
SRC_URI="http://lynx.isc.org/current/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
IUSE="bzip2 cjk gnutls ipv6 nls ssl unicode"

RDEPEND="sys-libs/ncurses[unicode?]
	sys-libs/zlib
	nls? ( virtual/libintl )
	ssl? (
		!gnutls? ( >=dev-libs/openssl-0.9.8 )
		gnutls? ( >=net-libs/gnutls-2.6.4 )
	)
	bzip2? ( app-arch/bzip2 )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	>=dev-util/pkgconfig-0.23"

S="${WORKDIR}/${PN}$(replace_all_version_separators - $(get_version_component_range 1-3))"

pkg_setup() {
	if ! use ssl ; then
		elog "SSL support disabled; you will not be able to access secure websites."
	fi
}

src_prepare() {
	# fix up toplevel makefile to enable parallel make (bug #262972)
	#
	# add '+' prefix to lines using $(MAKE_RECUR),
	# making sure '+' comes after leading whitespace
	sed -i -e '/$(MAKE_RECUR)/ s/\([[:blank:]]\)/\1+/' makefile.in || die

	# fix configure for openssl compiled with kerberos (bug #267749)
	epatch "${FILESDIR}"/${PN}-2.8.7-configure-openssl.patch

	# missing include of locale.h when compiled with -O0 (bug #286198)
	epatch "${FILESDIR}"/${PN}-2.8.7-include-locale.patch
}

src_configure() {
	local myargs

	if use ssl ; then
		# --with-gnutls and --with-ssl are alternatives,
		# the latter enabling openssl support so it should be
		# _not_ be used if gnutls ssl implementation is desired
		if use gnutls ; then
			myargs+=" --with-gnutls"
		else
			myargs+=" --with-ssl"
		fi
	fi

	if use unicode ; then
		myargs+=" --with-screen=ncursesw"
	fi

	econf \
		--enable-cgi-links \
		--enable-persistent-cookies \
		--enable-prettysrc \
		--enable-nsl-fork \
		--enable-file-upload \
		--enable-read-eta \
		--enable-color-style \
		--enable-scrollbar \
		--enable-included-msgs \
		--with-zlib \
		$(use_enable nls) \
		$(use_enable ipv6) \
		$(use_enable cjk) \
		$(use_enable unicode japanese-utf8) \
		$(use_with bzip2 bzlib) \
		${myargs}
}

src_install() {
	emake install DESTDIR="${D}" || die

	sed -i \
		-e "s|^HELPFILE.*$|HELPFILE:file://localhost/usr/share/doc/${PF}/lynx_help/lynx_help_main.html|" \
		"${D}"/etc/lynx.cfg || die
	if use unicode ; then
		sed -i \
			-e '/^#CHARACTER_SET:/ c\CHARACTER_SET:utf-8' \
			"${D}"/etc/lynx.cfg || die
	fi

	dodoc CHANGES COPYHEADER PROBLEMS README
	docinto docs
	dodoc docs/*
	docinto lynx_help
	dodoc lynx_help/*.txt
	dohtml -r lynx_help/*
}
