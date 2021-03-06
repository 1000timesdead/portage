# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/duby/duby-0.0.2.ebuild,v 1.1 2010/02/19 12:01:28 flameeyes Exp $

EAPI=2

USE_RUBY="jruby"

RUBY_FAKEGEM_SUFFIX="java"

RUBY_FAKEGEM_EXTRAINSTALL="javalib"

inherit ruby-fakegem

DESCRIPTION="Customizable typed programming language with Ruby-inspired syntax."
HOMEPAGE="http://kenai.com/projects/duby"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend virtual/ruby-test-unit

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}
	doins -r examples || die
}
