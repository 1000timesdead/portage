# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/pdb-extract/pdb-extract-3.004-r1.ebuild,v 1.2 2011/07/21 19:04:04 jlec Exp $

EAPI=3

inherit eutils toolchain-funcs multilib prefix

MY_P="${PN}-v${PV}-prod-src"

DESCRIPTION="Tools for extracting mmCIF data from structure determination applications"
HOMEPAGE="http://sw-tools.pdb.org/apps/PDB_EXTRACT/index.html"
SRC_URI="http://sw-tools.pdb.org/apps/PDB_EXTRACT/${MY_P}.tar.gz"

LICENSE="PDB"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="!<app-text/html-xml-utils-5.3"
DEPEND="${RDEPEND}
	>=sci-libs/cifparse-obj-7.025"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-cflags-install.patch \
		"${FILESDIR}"/${P}-gcc-4.3.patch \
		"${FILESDIR}"/${P}-Makefile.patch \
		"${FILESDIR}"/${P}-env.patch

	sed -i "s:GENTOOLIBDIR:$(get_libdir):g" \
		pdb-extract-v3.0/Makefile \
		|| die "Failed to fix libdir"

	# Get rid of unneeded directories, to make sure we use system files
	ebegin "Deleting redundant directories"
	rm -rf cif-file-v1.0 cifobj-common-v4.1 cifparse-obj-v7.0 \
		misclib-v2.2 regex-v2.2 tables-v8.0
	eend

	sed -i \
		-e "s:^\(CCC=\).*:\1$(tc-getCXX):g" \
		-e "s:^\(CC=\).*:\1$(tc-getCC):g" \
		-e "s:^\(GINCLUDES=\).*:\1-I${EPREFIX}/usr/include/cifparse-obj:g" \
		-e "s:^\(LIBDIR=\).*:\1${EPREFIX}/usr/$(get_libdir):g" \
		"${S}"/etc/make.* \
		|| die "Failed to fix makefiles"

	eprefixify pdb-extract-v3.0/Makefile etc/*
}

src_install() {
	dobin bin/pdb_extract{,_sf} \
		|| die "failed to install binaries"
	newbin bin/extract extract-pdb \
		|| die "failed to rename extract binary"
	dolib.a lib/pdb-extract.a  \
		|| die "failed to install library"
	insinto /usr/include/rcsb
	doins include/* \
		|| die "failed to install include files"
	dodoc README-source README \
		|| die "failed to install docs"
	insinto /usr/lib/rcsb/pdb-extract-data
	doins pdb-extract-data/*  \
		|| die "failed to install data files"

	cat >> "${T}"/envd <<- EOF
	PDB_EXTRACT="${EPREFIX}/usr/lib/rcsb/"
	PDB_EXTRACT_ROOT="${EPREFIX}/usr/"
	EOF

	newenvd "${T}"/envd 20pdb-extract \
		|| die "failed to install env files"
}

pkg_postinst() {
	ewarn "We moved extract to extract-pdb due to multiple collision of ${EROOT}usr/bin/extract"
}
