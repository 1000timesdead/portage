# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/luit/luit-1.1.0.ebuild,v 1.9 2011/02/14 18:49:57 xarthisius Exp $

EAPI=3

inherit xorg-2

DESCRIPTION="Locale and ISO 2022 support for Unicode terminals"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
RDEPEND="sys-libs/zlib
	x11-libs/libX11
	x11-libs/libfontenc"
DEPEND="${RDEPEND}"
