# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/scrollz/scrollz-2.1.ebuild,v 1.6 2011/06/30 17:12:32 binki Exp $

EAPI=4

DESCRIPTION="Advanced IRC client based on ircII"
HOMEPAGE="http://packages.qa.debian.org/s/scrollz.html"
SRC_URI="mirror://debian/pool/main/s/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ia64 ~ppc x86"
IUSE="gmp gnutls ipv6 socks5 ssl"

REQUIRED_USE="gnutls? ( ssl )"

RDEPEND="sys-libs/ncurses
	gmp? ( dev-libs/gmp )
	ssl? (
		gnutls? ( net-libs/gnutls )
		!gnutls? ( dev-libs/openssl )
		)"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${P}.orig

src_configure() {
	local _myssl

	if use ssl; then
		if use gnutls; then
			_myssl="--with-ssl"
		else
			_myssl="--with-openssl"
		fi
	fi

	econf \
		--with-default-server=irc.gentoo.org \
		$(use_enable socks5) \
		$(use_enable ipv6) \
		--enable-regexp \
		$(use_enable gmp fish) \
		${_myssl}
}

src_install() {
	einstall \
		sharedir="${ED}/usr/share" \
		mandir="${ED}/usr/share/man/man1"

	dodoc ChangeLog* NEWS README* todo
}
