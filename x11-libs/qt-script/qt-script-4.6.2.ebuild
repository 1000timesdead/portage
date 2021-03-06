# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-script/qt-script-4.6.2.ebuild,v 1.9 2010/09/13 21:22:19 klausman Exp $

EAPI="2"
inherit qt4-build

DESCRIPTION="The ECMAScript module for the Qt toolkit"
SLOT="4"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="iconv"

DEPEND="~x11-libs/qt-core-${PV}[aqua=,debug=]"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="src/script/"
QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
include/Qt/
include/QtCore/
include/QtScript/
src/corelib/
src/3rdparty/javascriptcore/
"

PATCHES=(
	"${FILESDIR}/qt-4.6-nolibx11.patch"
	"${FILESDIR}/qt-script-4.6.2-alpha.patch"
)

src_configure() {
	myconf="${myconf} $(qt_use iconv) -script -no-xkb  -no-fontconfig -no-xrender -no-xrandr
		-no-xfixes -no-xcursor -no-xinerama -no-xshape -no-sm -no-opengl
		-no-nas-sound -no-dbus -no-cups -no-nis -no-gif -no-libpng
		-no-libmng -no-libjpeg -no-openssl -system-zlib -no-webkit -no-phonon
		-no-qt3support -no-xmlpatterns -no-freetype -no-libtiff -no-accessibility
		-no-fontconfig -no-glib -no-opengl -no-svg -no-gtkstyle"
	qt4-build_src_configure
}
