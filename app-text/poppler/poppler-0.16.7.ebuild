# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/poppler/poppler-0.16.7.ebuild,v 1.5 2011/08/25 20:48:50 maekke Exp $

EAPI="2"

inherit cmake-utils

DESCRIPTION="PDF rendering library based on the xpdf-3.0 code base"
HOMEPAGE="http://poppler.freedesktop.org/"
SRC_URI="http://poppler.freedesktop.org/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE="cairo cjk curl cxx debug doc exceptions +introspection jpeg
jpeg2k +lcms png qt4 +utils +xpdf-headers"

# No test data provided
RESTRICT="test"

COMMON_DEPEND="
	>=media-libs/fontconfig-2.6.0
	>=media-libs/freetype-2.3.9
	sys-libs/zlib
	cairo? (
		dev-libs/glib:2
		>=x11-libs/cairo-1.10.0
		>=x11-libs/gtk+-2.20.1:2[introspection?]
		introspection? ( >=dev-libs/gobject-introspection-0.9.12 )
	)
	curl? ( net-misc/curl )
	jpeg? ( virtual/jpeg )
	jpeg2k? ( media-libs/openjpeg )
	lcms? ( =media-libs/lcms-1* )
	png? ( >=media-libs/libpng-1.4 )
	qt4? (
		x11-libs/qt-core:4
		x11-libs/qt-gui:4
	)
"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	!dev-libs/poppler
	!dev-libs/poppler-glib
	!dev-libs/poppler-qt3
	!dev-libs/poppler-qt4
	!app-text/poppler-utils
	cjk? ( >=app-text/poppler-data-0.2.1 )
"

DOCS=(AUTHORS ChangeLog NEWS README README-XPDF TODO)

src_configure() {
	mycmakeargs=(
		-DBUILD_GTK_TESTS=OFF
		-DBUILD_QT4_TESTS=OFF
		-DBUILD_CPP_TESTS=OFF
		-DWITH_Qt3=OFF
		-DENABLE_ABIWORD=OFF
		-DENABLE_SPLASH=ON
		-DENABLE_ZLIB=ON
		$(cmake-utils_use_enable curl LIBCURL)
		$(cmake-utils_use_enable cxx CPP)
		$(cmake-utils_use_enable jpeg2k LIBOPENJPEG)
		$(cmake-utils_use_enable lcms)
		$(cmake-utils_use_enable utils)
		$(cmake-utils_use_enable xpdf-headers XPDF_HEADERS)
		$(cmake-utils_use_with cairo)
		$(cmake-utils_use_with cairo GTK)
		$(cmake-utils_use_with introspection GObjectIntrospection)
		$(cmake-utils_use_with jpeg)
		$(cmake-utils_use_with png)
		$(cmake-utils_use_with qt4)
		$(cmake-utils_use exceptions USE_EXCEPTIONS)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use cairo && use doc; then
		# For now install gtk-doc there
		insinto /usr/share/gtk-doc/html/poppler
		doins -r "${S}"/glib/reference/html/* || die 'failed to install API documentation'
	fi
}

pkg_postinst() {
	ewarn "After upgrading app-text/poppler you may need to reinstall packages"
	ewarn "linking to it. If you're not a portage-2.2_rc user, you're advised"
	ewarn "to run revdep-rebuild"
}
