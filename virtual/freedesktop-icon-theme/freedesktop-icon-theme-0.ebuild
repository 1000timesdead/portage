# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/freedesktop-icon-theme/freedesktop-icon-theme-0.ebuild,v 1.2 2011/09/03 08:48:28 scarabeus Exp $

EAPI=4

DESCRIPTION="A virtual to choose between different icon themes"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86"
IUSE=""

RDEPEND="|| ( x11-themes/tango-icon-theme
	x11-themes/gnome-icon-theme
	kde-base/oxygen-icons
	lxde-base/lxde-icon-theme
	x11-themes/faenza-icon-theme )"
