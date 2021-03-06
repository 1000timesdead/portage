# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/facile/facile-1.1.ebuild,v 1.18 2011/01/03 21:12:19 dilfridge Exp $

EAPI="2"

inherit eutils

DESCRIPTION="A constraint programming library on integer and integer set finite domains written in OCaml."
HOMEPAGE="http://www.recherche.enac.fr/log/facile/"
SRC_URI="http://www.recherche.enac.fr/log/facile/distrib/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"

KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="+ocamlopt"

RDEPEND=">=dev-lang/ocaml-3.10.2[ocamlopt?]"
DEPEND="${RDEPEND}
	 sys-apps/sed"

src_prepare() {
	# Fix building on FreeBSD
	epatch "${FILESDIR}/${P}"-make.patch
	# Disable building native code objects if we dont have/want ocamlopt
	if ! use ocamlopt; then
		sed -i -e 's/\.opt//' src/Makefile || die "failed to change native code compiler to bytecode ones"
		sed -i -e 's/ facile\.cmxa//' src/Makefile || die "failed to remove native code objects"
		sed -i -e 's/\.opt/.out/g' \
			-e 's: src/facile\.cmxa::'\
			-e 's: src/facile\.a::'\
			-e 's:^.*facile\.cmxa::'\
			-e 's:^.*facile\.a::' Makefile || die "failed to remove native code objects"
	fi
}

src_configure(){
	# This is a custom configure script and it does not support standard options
	./configure --faciledir "${D}"$(ocamlc -where)/facile/
}

src_test() {
	emake check || die "emake check failed"
}

src_install(){
	dodir $(ocamlc -where)
	emake install || die "Installation failed"
	dodoc README || die "installing docs failed"
}
