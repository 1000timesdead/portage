# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/cola/cola-1.4.3.2.ebuild,v 1.2 2011/04/23 07:05:25 jlec Exp $

EAPI="3"

PYTHON_DEPEND="2"

inherit distutils eutils

DESCRIPTION="A sweet, carbonated git gui known for its sugary flavour and caffeine-inspired features."
HOMEPAGE="http://cola.tuxfamily.org/"
SRC_URI="http://cola.tuxfamily.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND="
	dev-python/jsonpickle
	dev-python/pyinotify
	dev-python/PyQt4
	dev-vcs/git"
DEPEND="${RDEPEND}
	doc? (
		app-text/asciidoc
		dev-python/sphinx
		app-text/xmlto )
	sys-devel/gettext
	test? ( dev-python/nose )"

# tests currently broken due to unfinished translation framework
RESTRICT="test"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	# don't install docs into wrong location
	sed -i \
		-e '/doc/d' \
		setup.py || die "sed failed"

	sed -i \
		-e  "s|'doc', 'git-cola'|'doc', '${PF}', 'html'|" \
		cola/resources.py || die "sed failed"

	# don't prefix install path with homedir
	rm setup.cfg

	epatch "${FILESDIR}"/1.3.8-disable-tests.patch

	python_convert_shebangs 2 bin/git-cola share/git-cola/bin/ssh-askpass
}

src_compile() {
	distutils_src_compile

	if use doc ; then
		cd share/doc/git-cola/
		emake all || die "building docs failed"
	fi
}

src_install() {
	distutils_src_install

	# remove bundled libraries
	rm -rf "${D}"/usr/share/git-cola/lib/{jsonpickle,simplejson}

	# remove wrong translation file
	rm -rf "${D}/usr/share/locale/"

	insinto /usr/share/locale
	doins -r share/locale/*

	cd share/doc/git-cola/
	dodoc *.txt

	if use doc ; then
		dohtml -r _build/html/*
		doman *.1
	else
		dohtml "${FILESDIR}/index.html"
	fi
}

src_test() {
	PYTHONPATH="${S}:${S}/build/lib:${PYTHONPATH}" LC_ALL="C" nosetests \
		--verbose --with-doctest --with-id --exclude=jsonpickle --exclude=json \
		|| die "running nosetests failed"
}

pkg_postinst() {
	python_mod_optimize /usr/share/git-cola/lib/cola
}

pkg_postrm() {
	python_mod_cleanup /usr/share/git-cola/lib/cola
}
