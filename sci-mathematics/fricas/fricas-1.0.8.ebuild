# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/fricas/fricas-1.0.8.ebuild,v 1.2 2010/01/08 16:49:45 grozin Exp $
EAPI=2
inherit elisp-common

DESCRIPTION="FriCAS is a fork of Axiom computer algebra system"
HOMEPAGE="http://${PN}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-full.tar.bz2"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~x86"

# Supported lisps, number 0 is the default
LISPS=(   sbcl cmucl gcl ecl    clisp clozurecl )
# . means just dev-lisp/${LISP}
# package-x.y.z means >=dev-lisp/package-x.y.z
DEPS=(    .    .     .   ecls-9 .     .         )
# command name: . means just ${LISP}
COMMAND=( .    lisp  .   .      .     ccl       )

IUSE="${LISPS[*]} X emacs"
RDEPEND="X? ( x11-libs/libXpm x11-libs/libICE )
	emacs? ( virtual/emacs )"

# Generating lisp deps
n=${#LISPS[*]}
for ((n--; n > 0; n--)); do
	LISP=${LISPS[$n]}
	DEP=${DEPS[$n]}
	if [ "${DEP}" = "." ]; then
		DEP="dev-lisp/${LISP}"
	else
		DEP=">=dev-lisp/${DEP}"
	fi
	RDEPEND="${RDEPEND} ${LISP}? ( ${DEP} ) !${LISP}? ("
done
RDEPEND="${RDEPEND} dev-lisp/${LISPS[0]}"
n=${#LISPS[*]}
for ((n--; n > 0; n--)); do
	RDEPEND="${RDEPEND} )"
done

DEPEND="${RDEPEND}"

# necessary for clisp and gcl
RESTRICT="strip"

src_configure() {
	local LISP n
	LISP=sbcl
	n=${#LISPS[*]}
	for ((n--; n > 0; n--)); do
		if use ${LISPS[$n]}; then
			LISP=${COMMAND[$n]}
			if [ "${LISP}" = "." ]; then
				LISP=${LISPS[$n]}
			fi
		fi
	done
	einfo "Using lisp: ${LISP}"

	# aldor is not yet in portage
	econf --disable-aldor --with-lisp=${LISP} $(use_with X x)
}

src_compile() {
	# bug #300132
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die 'emake install failed'
	dodoc README FAQ || die "dodoc failed"

	if use emacs; then
		sed -e 's|(setq load-path (cons (quote "/usr/lib/fricas/emacs") load-path)) ||' \
			-i "${D}"/usr/bin/efricas \
			|| die "sed efricas failed"
		elisp-install ${PN} "${D}"/usr/lib/${PN}/emacs/*.el
		elisp-site-file-install "${FILESDIR}"/64${PN}-gentoo.el
	else
		rm "${D}"/usr/bin/efricas || die "rm efricas failed"
	fi
	rm -r "${D}"/usr/lib/${PN}/emacs || die "rm -r emacs failed"
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
