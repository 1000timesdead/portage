# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/whois/whois-5.0.7.ebuild,v 1.1 2010/09/25 06:05:06 vapier Exp $

EAPI=3
inherit eutils toolchain-funcs

MY_P=${P/-/_}
DESCRIPTION="improved Whois Client"
HOMEPAGE="http://www.linux.it/~md/software/"
SRC_URI="mirror://debian/pool/main/w/whois/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
IUSE="nls"
RESTRICT="test" #59327

RDEPEND="net-dns/libidn"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.7.2-config-file.patch

	if use nls ; then
		sed -i -e 's:#\(.*pos\):\1:' Makefile
	else
		sed -i -e '/ENABLE_NLS/s:define:undef:' config.h
	fi
}

src_configure() { :;} # expected no-op

src_compile() {
	tc-export CC
	emake CFLAGS="${CFLAGS} ${CPPFLAGS}" HAVE_LIBIDN=1 || die
}

src_install() {
	emake BASEDIR="${ED}" prefix=/usr install || die
	insinto /etc
	doins whois.conf
	dodoc README debian/changelog

	if [[ ${USERLAND} != "GNU" ]]; then
		mv "${ED}"/usr/share/man/man1/{whois,mdwhois}.1
		mv "${ED}"/usr/bin/{whois,mdwhois}
	fi
}
