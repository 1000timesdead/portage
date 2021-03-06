# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/hippodraw/hippodraw-1.21.3-r3.ebuild,v 1.9 2011/07/16 19:38:27 jlec Exp $

EAPI=3

PYTHON_DEPEND="2"
PYTHON_USE_WITH="threads"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit autotools eutils multilib python qt4-r2

MY_PN=HippoDraw

DESCRIPTION="Highly interactive data analysis Qt environment for C++ and python"
HOMEPAGE="http://www.slac.stanford.edu/grp/ek/hippodraw/"
SRC_URI="
	ftp://ftp.slac.stanford.edu/users/pfkeb/${PN}/${MY_PN}-${PV}.tar.gz
	mirror://gentoo/${P}-gentoo.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples +fits +numpy root wcs"

CDEPEND="
	app-text/poppler[qt4]
	dev-libs/boost[python]
	media-libs/netpbm
	virtual/latex-base
	|| ( >=x11-libs/qt-assistant-4.7.0:4[compat] <x11-libs/qt-assistant-4.7.0:4 )
	x11-libs/qt-gui:4
	x11-libs/qt-qt3support:4
	x11-libs/qt-xmlpatterns:4
	fits? ( sci-libs/cfitsio )
	numpy? ( dev-python/numpy )
	root? ( >=sci-physics/root-5 )
	!root? ( sci-libs/minuit )
	wcs? ( sci-astronomy/wcslib )"

DEPEND="${CDEPEND}
	doc? ( app-doc/doxygen )"

RDEPEND="${CDEPEND}
	numpy? ( fits? ( dev-python/pyfits ) )"

S="${WORKDIR}"/${MY_PN}-${PV}

PATCHES=(
		"${WORKDIR}"/${P}-gcc4.3.patch
		"${WORKDIR}"/${P}-gcc4.4.patch
		"${WORKDIR}"/${P}-gcc45.patch
		"${WORKDIR}"/${P}-numarray.patch
		"${WORKDIR}"/${P}-test-fix.patch
		"${WORKDIR}"/${P}-minuit2.patch
		"${WORKDIR}"/${P}-wcslib.patch
		"${WORKDIR}"/${P}-qt4.patch
		"${WORKDIR}"/${P}-autoconf-2.64.patch
		"${WORKDIR}"/${P}-automake-1.11.patch
		"${FILESDIR}"/${P}-gold.patch
		)

pkg_setup() {
	python_pkg_setup
}

src_prepare() {
	qt4-r2_src_prepare

	echo "#!${EPREFIX}/bin/sh" > config/py-compile

	# fix the install doc directory to gentoo's one
	local docdir="${EPREFIX}"/usr/share/doc/${PF}
	sed -i \
		-e "s:\(docdir\).*=.*:\1= ${docdir}:" \
		-e "s:\(INSTALLDIR\).*=.*:\1= \$(DESTDIR)${docdir}/html:" \
		-e "/^DOCS_STR/s:\(DOCS_STR\).*=.*:\1 = \\\\\"${docdir}/html\\\\\":" \
		-e "s:\$(pkgdatadir)/examples:${docdir}/examples:" \
		-e 's:LICENSE:README:' \
		-e "s:BOOSTDIR = python:BOOSTDIR =:g" \
		{.,doc,examples,qt}/Makefile.am || die "sed for docdir failed"

	AT_M4DIR=config/m4 eautoreconf
}

src_configure() {
	local myconf="
		--disable-numarraybuild
		$(use_enable numpy numpybuild)
		$(use_enable doc help)"
	# All these longuish conf options are necessary
	# or else a huge patch
	myconf="${myconf} --with-Qt-include-dir=no"
	myconf="${myconf} --with-Qt-lib-dir=no"
	myconf="${myconf} --with-Qt-bin-dir=no"
	myconf="${myconf} --with-qt4-include=${EPREFIX}/usr/include/qt4"
	myconf="${myconf} --with-qt4-lib=${EPREFIX}/usr/$(get_libdir)/qt4"
	myconf="${myconf} --with-qt4-dir=${EPREFIX}/usr"

	if use root; then
		myconf="${myconf} --with-root-include=$(root-config --incdir)"
		myconf="${myconf} --with-root-lib=$(root-config --libdir)"
		myconf="${myconf} --with-minuit2-lib=no"
	else
		myconf="${myconf} --with-minuit2-include=${EPREFIX}/usr/include"
		myconf="${myconf} --with-minuit2-lib=${EPREFIX}/usr/$(get_libdir)"
		myconf="${myconf} --with-root-lib=no"
	fi

	if use fits; then
		myconf="${myconf} --with-cfitsio-include=${EPREFIX}/usr/include"
		myconf="${myconf} --with-cfitsio-lib=${EPREFIX}/usr/$(get_libdir)"
	else
		myconf="${myconf} --with-cfitsio-lib=no"
	fi

	if use wcs; then
		myconf="${myconf} --with-wcslib-include=${EPREFIX}/usr/include"
		myconf="${myconf} --with-wcslib-lib=${EPREFIX}/usr/$(get_libdir)"
	else
		myconf="${myconf} --with-wcslib-include=no"
		myconf="${myconf} --with-wcslib-lib=no"
	fi

	econf ${myconf} || die "econf failed"
}

src_compile() {
	emake || die "emake failed"
	if use doc; then
		emake -j1 docs || die "emake docs failed"
	fi
	python_copy_sources python
	compilation() {
	emake \
		PYTHON_INCLUDES="${EPREFIX}$(python_get_includedir)" \
		PYTHON_SITE_PACKAGES="${EPREFIX}$(python_get_sitedir)" \
		NUMARRAY_INCLUDE="${EPREFIX}$(python_get_sitedir)/numpy/core/include" \
		PY_INCLUDE="${EPREFIX}$(python_get_includedir)"
	}
	python_execute_function -s --source-dir python compilation
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	installation() {
		emake DESTDIR="${D}" \
			PYTHON_SITE_PACKAGES="${EPREFIX}$(python_get_sitedir)" \
			docsdir="${EPREFIX}"/usr/share/doc/${PF}/python \
			exampledir="${EPREFIX}"/usr/share/doc/${PF}/python/examples \
			install
	}
	python_execute_function -s --source-dir python installation
	python_clean_installation_image

	dosym ../${MY_PN}/hippoApp.png /usr/share/pixmaps/hippoApp.png
	make_desktop_entry hippodraw HippoDraw hippoApp
	if use examples; then
		insinto /usr/share/doc/${PF}/testsuite
		doins testsuite/*.py || die "examples install failed"
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.{fits,tnt,data,baddata}* || die
	else
		# these are automatically installed
		rm -rf "${D}"usr/share/doc/${PF}/examples || die
	fi
}

pkg_postinst() {
	python_mod_optimize ${MY_PN}
}

pkg_postrm() {
	python_mod_cleanup ${MY_PN}
}
