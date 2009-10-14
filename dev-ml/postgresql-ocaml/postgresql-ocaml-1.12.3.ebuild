# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/postgresql-ocaml/postgresql-ocaml-1.12.3.ebuild,v 1.1 2009/10/13 07:03:58 aballier Exp $

EAPI="2"

inherit findlib eutils

IUSE="examples +ocamlopt"

DESCRIPTION="A package for ocaml that provides access to PostgreSQL databases."
SRC_URI="http://ocaml.info/ocaml_sources/${P}.tar.gz"
HOMEPAGE="http://ocaml.info/home/ocaml_sources.html#toc9"

DEPEND=">=dev-lang/ocaml-3.11[ocamlopt?]
	>=virtual/postgresql-base-7.3
	>=virtual/postgresql-server-7.3"
RDEPEND="${DEPEND}"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~amd64 ~ppc ~x86"

src_compile() {
	cd "${S}/lib"
	emake -j1 byte-code-library || die "failed to build byte code library"
	if use ocamlopt; then
		emake -j1 native-code-library || die "failed to built nativde code library"
	fi
}

src_install () {
	use ocamlopt || export OCAMLFIND_INSTFLAGS="-optional"
	findlib_src_preinst
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS Changelog README.txt

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
