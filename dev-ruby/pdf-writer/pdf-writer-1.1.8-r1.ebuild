# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/pdf-writer/pdf-writer-1.1.8-r1.ebuild,v 1.2 2011/08/07 07:09:09 graaff Exp $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="ChangeLog manual.pwd README"

inherit ruby-fakegem

DESCRIPTION="A pure Ruby PDF document creation library."
HOMEPAGE="http://rubyforge.org/projects/ruby-pdf/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ia64 x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/color-1.4.0
	>=dev-ruby/transaction-simple-1.3.0"

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}
	doins -r demo images || die
}
