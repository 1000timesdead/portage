# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/numpy/numpy-1.6.0_rc3.ebuild,v 1.1 2011/05/08 00:36:49 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="*-jython"

inherit distutils eutils flag-o-matic toolchain-funcs versionator

MY_P="${P/_rc/rc}"
DOC_P="${PN}-1.5"

DESCRIPTION="Fast array and numerical python library"
HOMEPAGE="http://numpy.scipy.org/ http://pypi.python.org/pypi/numpy"
SRC_URI="mirror://sourceforge/numpy/${MY_P}.tar.gz
	doc? (
		http://docs.scipy.org/doc/${DOC_P}.x/numpy-html.zip -> ${DOC_P}-html.zip
		http://docs.scipy.org/doc/${DOC_P}.x/numpy-ref.pdf -> ${DOC_P}-ref.pdf
		http://docs.scipy.org/doc/${DOC_P}.x/numpy-user.pdf -> ${DOC_P}-user.pdf
	)"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="doc lapack test"

RDEPEND="dev-python/setuptools
	lapack? ( virtual/cblas virtual/lapack )"
DEPEND="${RDEPEND}
	doc? ( app-arch/unzip )
	lapack? ( dev-util/pkgconfig )
	test? ( >=dev-python/nose-0.10 )"

PYTHON_CFLAGS=("* + -fno-strict-aliasing")

DOCS="COMPATIBILITY DEV_README.txt THANKS.txt"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	python_pkg_setup

	# See progress in http://projects.scipy.org/scipy/numpy/ticket/573
	# with the subtle difference that we don't want to break Darwin where
	# -shared is not a valid linker argument
	if [[ ${CHOST} != *-darwin* ]]; then
		append-ldflags -shared
	fi

	# only one fortran to link with:
	# linking with cblas and lapack library will force
	# autodetecting and linking to all available fortran compilers
	use lapack || return
	[[ -z ${FC} ]] && FC=$(tc-getFC)
	# when fortran flags are set, pic is removed.
	FFLAGS="${FFLAGS} -fPIC"
	NUMPY_FCONFIG="config_fc --noopt --noarch"
	# workaround bug 335908
	[[ ${FC} == *gfortran* ]] && NUMPY_FCONFIG="${NUMPY_FCONFIG} --fcompiler=gnu95"
	export NUMPY_FCONFIG
}

src_unpack() {
	unpack ${MY_P}.tar.gz
	if use doc; then
		unzip -qo "${DISTDIR}"/${DOC_P}-html.zip -d html || die
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.1.0-f2py.patch"
	#epatch "${FILESDIR}/${PN}-1.3.0-fenv-freebsd.patch" # Bug #279487

	# Gentoo patch for ATLAS library names
	sed -i \
		-e "s:'f77blas':'blas':g" \
		-e "s:'ptf77blas':'blas':g" \
		-e "s:'ptcblas':'cblas':g" \
		-e "s:'lapack_atlas':'lapack':g" \
		numpy/distutils/system_info.py \
		|| die "sed system_info.py failed"

	if use lapack; then
		append-ldflags "$(pkg-config --libs-only-other cblas lapack)"
		sed -i -e '/NO_ATLAS_INFO/,+1d' numpy/core/setup.py || die
		local libdir="${EPREFIX}"/usr/$(get_libdir)
		cat >> site.cfg <<-EOF
			[atlas]
			include_dirs = $(pkg-config --cflags-only-I \
				cblas | sed -e 's/^-I//' -e 's/ -I/:/g')
			library_dirs = $(pkg-config --libs-only-L \
				cblas blas lapack | sed -e 's/^-L//' -e 's/ -L/:/g' -e 's/ //g'):${libdir}
			atlas_libs = $(pkg-config --libs-only-l \
				cblas blas | sed -e 's/^-l//' -e 's/ -l/, /g' -e 's/,.pthread//g')
			lapack_libs = $(pkg-config --libs-only-l \
				lapack | sed -e 's/^-l//' -e 's/ -l/, /g' -e 's/,.pthread//g')
			[blas_opt]
			include_dirs = $(pkg-config --cflags-only-I \
				cblas | sed -e 's/^-I//' -e 's/ -I/:/g')
			library_dirs = $(pkg-config --libs-only-L \
				cblas blas | sed -e 's/^-L//' -e 's/ -L/:/g' -e 's/ //g'):${libdir}
			libraries = $(pkg-config --libs-only-l \
				cblas blas | sed -e 's/^-l//' -e 's/ -l/, /g' -e 's/,.pthread//g')
			[lapack_opt]
			library_dirs = $(pkg-config --libs-only-L \
				lapack | sed -e 's/^-L//' -e 's/ -L/:/g' -e 's/ //g'):${libdir}
			libraries = $(pkg-config --libs-only-l \
				lapack | sed -e 's/^-l//' -e 's/ -l/, /g' -e 's/,.pthread//g')
		EOF
	else
		export {ATLAS,PTATLAS,BLAS,LAPACK,MKL}=None
	fi

	export CC="$(tc-getCC) ${CFLAGS}"
}

src_compile() {
	distutils_src_compile ${NUMPY_FCONFIG}
}

src_test() {
	testing() {
		"$(PYTHON)" setup.py ${NUMPY_FCONFIG} build -b "build-${PYTHON_ABI}" install \
			--home="${S}/test-${PYTHON_ABI}" --no-compile || die "install test failed"
		pushd "${S}/test-${PYTHON_ABI}/"lib* > /dev/null
		PYTHONPATH=python "$(PYTHON)" -c "import numpy; numpy.test()" 2>&1 | tee test.log
		grep -Eq "^(ERROR|FAIL):" test.log && return 1
		popd > /dev/null
		rm -fr test-${PYTHON_ABI}
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install ${NUMPY_FCONFIG}

	delete_txt() {
		rm -f "${ED}"$(python_get_sitedir)/numpy/*.txt
	}
	python_execute_function -q delete_txt

	docinto f2py
	dodoc numpy/f2py/docs/*.txt || die "dodoc f2py failed"
	doman numpy/f2py/f2py.1 || die "doman failed"

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r "${WORKDIR}"/html || die
		doins  "${DISTDIR}"/${DOC_P}*pdf || die
	fi
}
