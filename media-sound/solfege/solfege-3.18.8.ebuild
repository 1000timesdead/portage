# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/solfege/solfege-3.18.8.ebuild,v 1.1 2011/06/02 01:36:21 radhermit Exp $

EAPI=2
PYTHON_DEPEND="2:2.6"
PYTHON_USE_WITH="sqlite"

inherit python

DESCRIPTION="GNU Solfege is a program written to help you practice ear training."
HOMEPAGE="http://www.solfege.org"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="oss"

RDEPEND=">=dev-python/pygtk-2.12"
DEPEND="dev-lang/swig
	sys-devel/gettext
	sys-apps/texinfo
	dev-util/pkgconfig
	dev-libs/libxslt
	app-text/txt2man
	>=app-text/docbook-xsl-stylesheets-1.60"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	sed -i -e '/^CFLAGS/s:-I/usr/src/linux/include::' \
		solfege/soundcard/Makefile || die "sed failed"
}

src_configure() {
	local xslloc=$( xmlcatalog /etc/xml/catalog	http://docbook.sourceforge.net/release/xsl/current/html/chunk.xsl | sed 's@file://@@' )

	econf \
		--enable-docbook-stylesheet=${xslloc} \
		$(use_enable oss oss-sound)
}

src_compile() {
	emake skipmanual=yes || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" nopycompile=YES skipmanual=yes install || die "emake install failed"
	dodoc AUTHORS *hange*og FAQ README
}
