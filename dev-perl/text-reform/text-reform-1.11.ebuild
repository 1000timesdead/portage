# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/text-reform/text-reform-1.11.ebuild,v 1.21 2010/12/03 00:56:40 xmw Exp $

inherit perl-module

MY_P=Text-Reform-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Manual text wrapping and reformatting"
SRC_URI="mirror://cpan/authors/id/D/DC/DCONWAY/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~dconway/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 s390 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-lang/perl"
