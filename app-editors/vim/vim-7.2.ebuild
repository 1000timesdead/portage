# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/vim/vim-7.2.ebuild,v 1.6 2008/08/15 18:42:59 maekke Exp $

inherit vim

VIM_VERSION="7.2"
VIM_GENTOO_PATCHES="vim-${VIM_VERSION}-gentoo-patches.tar.bz2"

SRC_URI="ftp://ftp.vim.org/pub/vim/unix/vim-${VIM_VERSION}.tar.bz2
	ftp://ftp.vim.org/pub/vim/extra/vim-${VIM_VERSION}-lang.tar.gz
	ftp://ftp.vim.org/pub/vim/extra/vim-${VIM_VERSION}-extra.tar.gz
	mirror://gentoo/${VIM_GENTOO_PATCHES}"

S="${WORKDIR}/vim${VIM_VERSION/.}"
DESCRIPTION="Vim, an improved vi-style text editor"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~m68k ppc ppc64 ~s390 ~sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""
DEPEND="${DEPEND}
	!minimal? ( ~app-editors/vim-core-${PV} )"
RDEPEND="${RDEPEND}
	!<app-editors/nvi-1.81.5-r4
	!minimal? ( ~app-editors/vim-core-${PV} )"
