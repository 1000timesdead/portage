# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTTP-DAV/HTTP-DAV-0.38.ebuild,v 1.5 2009/10/28 18:11:14 armin76 Exp $

EAPI=2

MODULE_AUTHOR=OPERA
inherit perl-module

DESCRIPTION="A WebDAV client library for Perl5"

SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86"
IUSE=""

DEPEND="dev-perl/libwww-perl
	dev-perl/XML-DOM"
RDEPEND="${DEPEND}"

SRC_TEST="do"
