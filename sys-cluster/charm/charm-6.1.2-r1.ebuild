# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/charm/charm-6.1.2-r1.ebuild,v 1.1 2009/06/07 23:48:39 je_fro Exp $

inherit eutils toolchain-funcs flag-o-matic multilib

DESCRIPTION="Charm++ is a message-passing parallel language and runtime system."
LICENSE="charm"
HOMEPAGE="http://charm.cs.uiuc.edu/"
SRC_URI="http://charm.cs.uiuc.edu/distrib/${P}_src.tar.gz"
S="${WORKDIR}/${P}"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cmkopt tcp smp doc"

DEPEND="doc? ( app-text/poppler
		dev-tex/latex2html
		virtual/tex-base
		)"

RDEPEND="${DEPEND}"

case ${ARCH} in

	x86)
		CHARM_ARCH="net-linux" ;;

	amd64)
		CHARM_ARCH="net-linux-amd64" ;;
esac

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-charmrun.patch"

	# TCP instead of default UDP for socket comunication
	# protocol
	if use tcp; then
		CHARM_OPTS="${CHARM_OPTS} tcp"
	fi

	# enable direct SMP support using shared memory
#	if use smp && [ "${ARCH}" != "amd64" ]; then
	if use smp; then
		CHARM_OPTS="${CHARM_OPTS} smp"
	fi

	# CMK optimization
	if use cmkopt; then
		append-flags -DCMK_OPTIMIZE=1
	fi

	echo "charm opts: ${CHARM_OPTS}"
}

src_compile() {
	# build charmm++ first
	cd "${S}"
	./build charm++ ${CHARM_ARCH} ${CHARM_OPTS} ${CFLAGS} || \
		die "Failed to build charm++"

	# make pdf/html docs
	if use doc; then
		cd "${S}"/doc
		make doc || die "failed to create pdf/html docs"
	fi
}

src_install() {
	# make charmc play well with gentoo before
	# we move it into /usr/bin
	epatch "${FILESDIR}/${P}-charmc-gentoo.patch"

	sed -e "s|gentoo-include|${P}|" \
		-e "s|gentoo-libdir|$(get_libdir)|g" \
		-e "s|VERSION|${P}/VERSION|" \
		-i ./src/scripts/charmc || die "failed patching charmc script"

	# install binaries
	cd "${S}"/bin
	dobin ./charmd ./charmd_faceless ./charmr* ./charmc ./charmxi \
		./conv-cpm ./dep.pl || die "Failed to install binaries"

	# install headers
	cd "${S}"/include
	insinto /usr/include/${P}
	doins * || die "failed to install header files"

	# install static libs
	cd "${S}"/lib
	dolib.a * || die "failed to install static libs"

	# install shared libs
	cd "${S}"/lib_so
	dolib.so * || die "failed to install shared libs"

	# basic docs
	cd "${S}"
	dodoc CHANGES README  || die "Failed to install docs"

	# install examples
	find examples/ -name 'Makefile' | xargs sed \
		-r "s:(../)+bin/charmc:/usr/bin/charmc:" -i || \
		die "Failed to fix examples"
	find examples/ -name 'Makefile' | xargs sed \
		-r "s:./charmrun:./charmrun ++local:" -i || \
		die "Failed to fix examples"
	insinto /usr/share/doc/${PF}/examples
	doins -r examples/charm++/*

	# pdf/html docs
	if use doc; then
		cd "${S}"/doc
		# install pdfs
		insinto /usr/share/doc/${PF}/pdf
		doins  doc/pdf/* || die "failed to install pdf docs"
		# install html
		docinto html
		dohtml -r doc/html/* || die "failed to install html docs"
	fi
}

pkg_postinst() {
	echo
	einfo "Please test your charm installation by copying the"
	einfo "content of /usr/share/doc/${PF}/examples to a"
	einfo "temporary location and run 'make test'."
	echo
}
