# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/nano-methods/nano-methods-0.8.2-r1.ebuild,v 1.1 2010/06/26 07:46:40 graaff Exp $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_NAME="nano"

# Test suite require reap which we don't have packaged yet.
RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="ANN-0.8.1 ChangeLog README README.dev TODO"

inherit ruby-fakegem

DESCRIPTION="Ruby's Atomic Library"
HOMEPAGE="http://nano.rubyforge.org/"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc64 ~x86"
IUSE=""
