# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/cns/cns-1.1.ebuild,v 1.10 2011/06/21 16:05:16 jlec Exp $

inherit eutils fortran-2 toolchain-funcs

MY_PN="${PN}_solve"
MY_P="${MY_PN}_${PV}"

DESCRIPTION="Crystallography and NMR System"
HOMEPAGE="http://cns.csb.yale.edu/"
SRC_URI="
	${MY_P}_basic_inputs.tar.gz
	${MY_P}_data.tar.gz
	test? ( ${MY_P}_test.tar.gz )"

SLOT="0"
LICENSE="cns"
KEYWORDS="ppc x86"
IUSE="test"

RDEPEND="
	virtual/fortran
	app-shells/tcsh"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

RESTRICT="fetch"

pkg_nofetch() {
	einfo "Fill out the form at http://cns.csb.yale.edu/cns_request/"
	einfo "and place these files:"
	einfo ${A}
	einfo "in ${DISTDIR}."
}

get_fcomp() {
	case $(tc-getFC) in
		*gfortran* )
			FCOMP="gfortran" ;;
		ifort )
			FCOMP="ifc" ;;
		* )
			FCOMP=$(tc-getFC) ;;
	esac
}
src_unpack() {
	get_fcomp
	unpack ${A}

	# The length of time must be at least 10, not 9
	# http://gcc.gnu.org/ml/fortran/2006-02/msg00198.html
	epatch "${FILESDIR}"/${PV}-time-length-10.patch

	# Set up location for the build directory
	# Uses obsolete `sort` syntax, so we set _POSIX2_VERSION
	sed -i \
		-e "s:_CNSsolve_location_:${S}:g" \
		-e "17 s:\(.*\):\1\nsetenv _POSIX2_VERSION 199209:g" \
		"${S}"/cns_solve_env
}

src_compile() {
	local GLOBALS
	if [[ $(tc-getFC) =~ g77 ]]; then
		GLOBALS="-fno-globals"
	fi

	# make install really means build, since it's expected to be used in-place
	emake \
		CC="$(tc-getCC)" \
		F77=$(tc-getFC) \
		LD=$(tc-getFC) \
		CCFLAGS="${CFLAGS} -DCNS_ARCH_TYPE_\$(CNS_ARCH_TYPE) \$(EXT_CCFLAGS)" \
		F77OPT="${FFLAGS:- -O2} \$(CNS_MALIGN_I86)" \
		F77STD="${GLOBALS}" \
		LDFLAGS="${LDFLAGS}" \
		g77install \
		|| die "emake failed"
}

src_test() {
	# We need to force on g77 manually, because we can't get aliases working
	# when we source in a -c
	einfo "Running tests ..."
	csh -c \
		"setenv CNS_G77; source cns_solve_env; make run_tests" \
		|| die "tests failed"
	einfo "Displaying test results ..."
	cat "${S}"/*_g77/test/*.diff-test
}

src_install() {
	# Install to locations resembling FHS
	sed -i \
		-e "s:${S}:usr:g" \
		-e "s:^\(setenv CNS_SOLVE.*\):\1\nsetenv CNS_ROOT usr:g" \
		-e "s:^\(setenv CNS_SOLVE.*\):\1\nsetenv CNS_DATA \$CNS_ROOT/share/data:g" \
		-e "s:^\(setenv CNS_SOLVE.*\):\1\nsetenv CNS_DOC \$CNS_ROOT/share/doc/${PF}:g" \
		-e "s:CNS_MODULE \$CNS_SOLVE/modules:CNS_MODULE \$CNS_DATA/modules:g" \
		-e "s:\$CNS_LIB:\$CNS_DATA:g" \
		-e "s:CNS_HELPLIB \$CNS_SOLVE/helplib:CNS_HELPLIB \$CNS_DATA/helplib:g" \
		-e "s:\$CNS_SOLVE/bin/cns_info:\$CNS_DATA/bin/cns_info:g" \
		"${S}"/cns_solve_env

	# Get rid of setup stuff we don't need in the installed script
	sed -i \
		-e "83,$ d" \
		-e "37,46 d" \
		"${S}"/cns_solve_env

	newbin "${S}"/*_g77/bin/cns_solve* cns_solve \
		|| die "install cns_solve failed"

	# Can be run by either cns_solve or cns
	dosym cns_solve /usr/bin/cns

	# Don't want to install this
	rm -f "${S}"/*_g77/utils/Makefile

	dobin "${S}"/*_g77/utils/* || die "install utils failed"

	dobin "${S}"/bin/cns_{edit,header,transfer,web} || die "install bin failed"

	insinto /usr/share/cns
	doins -r "${S}"/libraries "${S}"/modules "${S}"/helplib
	doins "${S}"/bin/cns_info
	doins "${S}"/cns_solve_env

	dohtml \
		-A iq,cgi,csh,cv,def,fm,gif,hkl,inp,jpeg,lib,link,list,mask,mtf,param,pdb,pdf,pl,ps,sc,sca,sdb,seq,tbl,top \
		-f all_cns_info_template,omac,def \
		-r doc/html/*

	# Conflits with app-text/dos2unix
	rm -f "${D}"/usr/bin/dos2unix
}

pkg_postinst() {
	ewarn "You must source ${ROOT}usr/share/cns/cns_solve_env"
	ewarn "before running CNS. It's a C-shell script,"
	ewarn "so you also must be using csh or tcsh."
}
