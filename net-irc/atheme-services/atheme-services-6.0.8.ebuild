# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/atheme-services/atheme-services-6.0.8.ebuild,v 1.3 2011/06/14 03:07:58 binki Exp $

EAPI=4

inherit eutils flag-o-matic perl-module prefix

DESCRIPTION="A portable and secure set of open-source and modular IRC services"
HOMEPAGE="http://atheme.net/"
SRC_URI="http://atheme.net/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86 ~x86-fbsd"
IUSE="largenet ldap nls +pcre perl profile ssl"

RDEPEND="dev-libs/libmowgli
	ldap? ( net-nds/openldap )
	nls? ( sys-devel/gettext )
	pcre? ( dev-libs/libpcre )
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	# the dependency calculation puts all of the .c files together and
	# overwhelms cc1 with this flag :-(
	filter-flags -combine

	if use profile; then
		# bug #371119
		ewarn "USE=\"profile\" is incompatible with the hardened profile's -pie flag."
		ewarn "Disabling PIE. Please ignore any warning messages about -nopie being invalid."
		append-flags -nopie
	fi

	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-configure-disable.patch

	# fix docdir
	sed -i -e 's/\(^DOCDIR.*=.\)@DOCDIR@/\1@docdir@/' extra.mk.in || die

	# basic logging config directive fix
	sed -i -e '/^logfile/s;var/\(.*\.log\);'"${EPREFIX}"'/var/log/atheme/\1;g' dist/* || die

	# QA against bundled libs
	rm -rf libmowgli || die

	# Get useful information into build.log
	sed -i -e '/^\.SILENT:$/d' buildsys.mk.in || die
}

src_configure() {
	econf \
		--sysconfdir="${EPREFIX}"/etc/${PN} \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--localstatedir="${EPREFIX}"/var \
		--enable-fhs-paths \
		--enable-contrib \
		$(use_enable largenet large-net) \
		$(use_with ldap) \
		$(use_with nls) \
		$(use_enable profile) \
		$(use_with pcre) \
		$(use_enable ssl)
}

src_install() {
	emake DESTDIR="${D}" install

	insinto /etc/${PN}
	for conf in dist/*.example; do
		# The .cron file isn't meant to live in /etc/${PN}, so only
		# install a .example version.
		[[ ${conf} == *cron* ]] && continue

		newins ${conf} $(basename ${conf} .example)
	done

	fowners -R 0:${PN} /etc/${PN}
	keepdir /var/{lib,log}/atheme
	fowners ${PN}:${PN} /var/{lib,log}/atheme
	fperms -R 640 /etc/${PN}
	fperms 750 /etc/${PN} /var/{lib,log,run}/atheme

	cp "${FILESDIR}"/${PN}.initd.in "${T}"/${PN}.initd || die
	eprefixify "${T}"/${PN}.initd
	newinitd "${T}"/${PN}.initd ${PN}

	# contributed scripts and such:
	insinto /usr/share/doc/${PF}/contrib
	doins contrib/*.{c,pl,php,py,rb}

	if use perl; then
		perlinfo
		insinto "${VENDOR_LIB}"
		doins -r contrib/Atheme{,.pm}
	fi
}
