# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/locale/locale-2.0.5-r1.ebuild,v 1.2 2011/01/10 18:05:35 graaff Exp $

EAPI=2

USE_RUBY="ruby18 ruby19 jruby ree18"

RUBY_FAKEGEM_TASK_DOC="rerdoc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="ChangeLog README.rdoc"

RUBY_FAKEGEM_TASK_TEST="test"

inherit ruby-fakegem

DESCRIPTION="A pure ruby library which provides basic APIs for localization."
HOMEPAGE="http://locale.rubyforge.org/"
LICENSE="|| ( Ruby GPL-2 )"

KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-macos"
SLOT="0"
IUSE=""

ruby_add_bdepend "test? ( || ( virtual/ruby-test-unit dev-ruby/test-unit:2 ) )"

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}
	doins -r samples || die
}
