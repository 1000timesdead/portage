# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rubymail/rubymail-1.0.0-r1.ebuild,v 1.2 2010/08/15 13:47:22 a3li Exp $

EAPI=2
USE_RUBY="ruby18"

inherit ruby-ng

DESCRIPTION="A mail handling library for Ruby"
HOMEPAGE="http://raa.ruby-lang.org/project/rubymail/"
SRC_URI="http://rubyforge.org/frs/download.php/30221/rmail-${PV}.tgz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc"
S="${WORKDIR}/rmail-${PV}"

ruby_add_bdepend "doc? ( dev-ruby/rake )"

each_ruby_configure() {
	${RUBY} install.rb config --prefix=/usr || die
}

each_ruby_compile() {
	${RUBY} install.rb setup || die
}

all_ruby_compile() {
	use doc && (rake rdoc || die)
}

each_ruby_test() {
	${RUBY} test/runtests.rb || die "runtests.rb failed."
}

each_ruby_install() {
	${RUBY} install.rb config --prefix="${D}/usr" || die
	${RUBY} install.rb install || die
}

all_ruby_install() {
	dodoc NEWS NOTES README THANKS TODO || die
	use doc && (dohtml -r html/* || die)
	cp -r guide "${D}/usr/share/doc/${PF}" || die
}
