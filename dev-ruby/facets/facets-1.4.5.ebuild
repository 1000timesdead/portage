# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/facets/facets-1.4.5.ebuild,v 1.6 2010/05/22 15:14:01 flameeyes Exp $

inherit ruby gems

IUSE=""

# upstream switched to a strange naming scheme
# MY_P=$PN-${PV:0:4}"."${PV:4:2}"."${PV:6:2}

USE_RUBY="ruby18"

DESCRIPTION="Facets is an extension library adding extra functionality to Ruby"
HOMEPAGE="http://facets.rubyforge.org/"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="amd64 ia64 ppc64 x86"

DEPEND=">=dev-lang/ruby-1.8.5"
