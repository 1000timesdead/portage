# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit eutils versionator multilib toolchain-funcs

MY_PN="OpenFOAM"
MY_PV=$(get_version_component_range 1-2)
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="OpenFOAM - utilities"
HOMEPAGE="http://www.opencfd.co.uk/openfoam/"
SRC_URI="mirror://sourceforge/foam/${MY_P}.General.gtgz
	http://omploader.org/vcWF1/${P}.patch
	http://omploader.org/vcWFz/openfoam-kernel-${PVR}.patch"

LICENSE="GPL-2"
SLOT="1.5"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!=sci-libs/openfoam-${MY_PV}*
	!=sci-libs/openfoam-bin-${MY_PV}*
	=sci-libs/openfoam-solvers-${MY_PV}*"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if ! version_is_at_least 4.1 $(gcc-version) ; then
		die "${PN} requires >=sys-devel/gcc-4.1 to compile."
	fi
}

src_unpack() {
	ln -s "${DISTDIR}"/${MY_P}.General.gtgz ${MY_P}.General.tgz
	unpack ./${MY_P}.General.tgz

	cd "${S}"
	epatch "${FILESDIR}"/${MY_P}-compile.patch

	epatch "${DISTDIR}"/${P}.patch
	epatch "${DISTDIR}"/openfoam-kernel-${PVR}.patch
	chmod +x applications/utilities/postProcessing/graphics/ensightFoamReader/Allwmake
}

src_compile() {
	cp -a /usr/$(get_libdir)/${MY_PN}/${MY_P}/etc/{bashrc,settings.sh} "${S}"/etc/. || die "cannot copy bashrc"

	# This is a hack, due to the meta ebuild:
	sed -i -e "s|FOAM_LIB=\$WM_PROJECT_DIR/lib|FOAM_LIB=/usr/$(get_libdir)/${MY_PN}/${MY_P}/lib|"	\
		-e "s|FOAM_LIBBIN=\$FOAM_LIB|FOAM_LIBBIN=\$WM_PROJECT_DIR/lib|"	\
		-e "s|_foamAddLib \$FOAM_USER_LIBBIN|_foamAddLib \$FOAM_LIB|"	\
		etc/settings.sh || die "could not replace paths"

	sed -i -e "s|-L\$(LIB_WM_OPTIONS_DIR)|-L\$(LIB_WM_OPTIONS_DIR) -L/usr/$(get_libdir)/${MY_PN}/${MY_P}/lib|" \
		wmake/Makefile || die "could not replace search paths"

	sed -i -e "s|(FOAM_LIBBIN)|(FOAM_LIB)|" applications/utilities/postProcessing/velocityField/{flowType,Pe,uprime,vorticity,enstrophy,Q,Co,Lambda2,Mach}/Make/options	|| die "cannot change LIB dir"
	sed -i -e "s|(FOAM_LIBBIN)|(FOAM_LIB)|" applications/utilities/postProcessing/miscellaneous/execFlowFunctionObjects/Make/options	|| die "cannot change LIB dir"

	export FOAM_INST_DIR="${WORKDIR}"
	source etc/bashrc

	cd applications/utilities
	wmake all || die "could not build OpenFOAM utilities"
}

src_install() {
	insopts -m0755
	insinto /usr/$(get_libdir)/${MY_PN}/${MY_P}/applications/bin
	doins -r applications/bin/*

	insinto /usr/$(get_libdir)/${MY_PN}/${MY_P}/lib
	doins -r lib/*
}