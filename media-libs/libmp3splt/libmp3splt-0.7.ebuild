# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmp3splt/libmp3splt-0.7.ebuild,v 1.1 2011/08/03 19:31:12 sping Exp $

EAPI=2
inherit autotools multilib

DESCRIPTION="a library for mp3splt to split mp3 and ogg files without decoding."
HOMEPAGE="http://mp3splt.sourceforge.net"
SRC_URI="mirror://sourceforge/mp3splt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc pcre"

RDEPEND="media-libs/libmad
	media-libs/libvorbis
	media-libs/libogg
	media-libs/libid3tag
	pcre? ( dev-libs/libpcre )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen media-gfx/graphviz )
	sys-apps/findutils"

src_prepare() {
	if ! use doc ; then
		epatch "${FILESDIR}"/${P}-disable-docs.patch
	fi
	epatch "${FILESDIR}"/${P}-flags.patch

	eautoconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--disable-static \
		$(use_enable pcre) \
		--disable-cutter  # TODO package cutter <http://cutter.sourceforge.net/>
}

src_compile() {
	default

	if use doc ; then
		emake -C doc html || die
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die
	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins -r doc/html || die  # TODO handle latex output as well
	fi
	dodoc AUTHORS ChangeLog LIMITS NEWS README TODO || die
	find "${D}"/usr -name '*.la' -delete
}
