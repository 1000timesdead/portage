# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Base/Test-Base-0.58.ebuild,v 1.8 2009/05/16 08:33:55 aballier Exp $

EAPI=2

MODULE_AUTHOR=INGY
inherit perl-module

DESCRIPTION="A Data Driven Testing Framework"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ~ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=virtual/perl-Test-Simple-0.62
	>=dev-perl/Spiffy-0.30
	dev-perl/Test-Deep"
RDEPEND="${DEPEND}"

SRC_TEST="do"
