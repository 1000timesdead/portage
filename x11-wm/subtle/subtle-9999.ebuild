# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/subtle/subtle-9999.ebuild,v 1.2 2011/09/13 16:17:40 mr_bones_ Exp $

EAPI="4"
USE_RUBY="ruby19"

inherit mercurial ruby-ng

EHG_REPO_URI="http://hg.subforge.org/subtle"

DESCRIPTION="A manual tiling window manager"
HOMEPAGE="http://subforge.org/projects/subtle/wiki"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug doc test +xft xinerama xpm +xrandr +xtest"

RDEPEND="x11-libs/libX11
	xft? ( x11-libs/libXft )
	xinerama? ( x11-libs/libXinerama )
	xpm? ( x11-libs/libXpm )
	xtest? ( x11-libs/libXtst )
	xrandr? ( x11-libs/libXrandr )"
DEPEND="${RDEPEND}"
#	test? (
#		x11-terms/xterm
#		x11-base/xorg-server[xvfb]
#	)"

ruby_add_rdepend "dev-ruby/archive-tar-minitar"
ruby_add_bdepend "dev-ruby/rake"

# Requires dev-ruby/riot which isn't in the tree yet
RESTRICT="test"

all_ruby_unpack() {
	mercurial_src_unpack
}

each_ruby_configure() {
	local myconf
	use debug && myconf+=" debug=yes" || myconf+=" debug=no"
	use xft && myconf+=" xft=yes" || myconf+=" xft=no"
	use xinerama && myconf+=" xinerama=yes" || myconf+=" xinerama=no"
	use xpm && myconf+=" xpm=yes" || myconf+=" xpm=no"
	use xtest && myconf+=" xtest=yes" || myconf+=" xtest=no"
	use xrandr && myconf+=" xrandr=yes" || myconf+=" xrandr=no"

	${RUBY} -S rake destdir="${D}" ${myconf} config || die
}

each_ruby_compile() {
	${RUBY} -S rake build || die
}

each_ruby_test() {
	${RUBY} test/test.rb || die "tests failed"
}

each_ruby_install() {
	${RUBY} -S rake install || die
}

all_ruby_install() {
	dodir /etc/X11/Sessions
	cat <<-EOF > "${D}/etc/X11/Sessions/${PN}"
		#!/bin/sh
		/usr/bin/subtle
	EOF
	fperms a+x /etc/X11/Sessions/${PN}

	dodoc AUTHORS NEWS

	if use doc ; then
		rake rdoc || die
		dohtml -r html/*
	fi
}

pkg_postinst() {
	elog "Note that surserver will currently not work since dev-ruby/datamapper"
	elog "is not in the tree yet."
}
