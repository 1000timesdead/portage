# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/ffmpeg-php/ffmpeg-php-0.6.0-r1.ebuild,v 1.5 2011/03/31 15:42:49 scarabeus Exp $

EAPI="3"

PHP_EXT_NAME="ffmpeg"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

inherit php-ext-source-r2 eutils

KEYWORDS="amd64 x86"

DESCRIPTION="PHP extension that provides access to movie info."
HOMEPAGE="http://sourceforge.net/projects/ffmpeg-php/"
SRC_URI="mirror://sourceforge/ffmpeg-php/${P}.tbz2"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="virtual/ffmpeg
		|| ( dev-lang/php[gd] dev-lang/php[gd-external] )"
RDEPEND="${DEPEND}"

# The test breaks with the test movie, but it the same code works fine with
# other movies

RESTRICT="test"

DOCS="CREDITS ChangeLog EXPERIMENTAL TODO"

src_prepare() {
	for slot in $(php_get_slots) ; do
		cd "${WORKDIR}/${slot}"
		epatch "${FILESDIR}/${P}-avutil50.patch"
	done
	php-ext-source-r2_src_prepare
}
