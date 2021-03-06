# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/POE-API-Peek/POE-API-Peek-2.190.0.ebuild,v 1.1 2011/09/11 01:28:10 robbat2 Exp $

EAPI=4

MODULE_AUTHOR=BINGOS
MODULE_VERSION=2.19
inherit perl-module

DESCRIPTION="Peek into the internals of a running POE env"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/Devel-Size
	>=dev-perl/POE-1.311.0"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.31"

SRC_TEST=do
