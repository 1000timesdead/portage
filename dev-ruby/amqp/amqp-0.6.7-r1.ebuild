# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/amqp/amqp-0.6.7-r1.ebuild,v 1.1 2011/08/06 14:08:11 graaff Exp $

EAPI=4
USE_RUBY="ruby18 ree18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST="none"

inherit ruby-fakegem

DESCRIPTION="AMQP client implementation in Ruby/EventMachine"
HOMEPAGE="http://amqp.rubyforge.org/"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/bacon )"
ruby_add_rdepend ">=dev-ruby/eventmachine-0.12.4"

each_ruby_test() {
	${RUBY} -S bacon -Ilib lib/amqp.rb || die
}

all_ruby_install() {
	dodoc -r doc examples protocol research
}
