# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/log-dispatch/log-dispatch-2.22.ebuild,v 1.7 2009/12/10 09:46:18 tove Exp $

MODULE_AUTHOR=DROLSKY
MY_PN=Log-Dispatch
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}
inherit perl-module

DESCRIPTION="Dispatches messages to multiple Log::Dispatch::* objects"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 ia64 ~ppc sparc x86"
IUSE=""

SRC_TEST="do"

RDEPEND="dev-perl/Params-Validate
	virtual/perl-Sys-Syslog
	dev-lang/perl"
DEPEND="${RDEPEND}
	>=virtual/perl-Module-Build-0.28"
