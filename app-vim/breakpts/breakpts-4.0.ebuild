# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/breakpts/breakpts-4.0.ebuild,v 1.2 2010/11/11 13:43:27 hwoarang Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: sets vim breakpoints visually"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=618"
LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="
	|| ( >=app-editors/vim-7.0 >=app-editors/gvim-7.0 )
	>=app-vim/multvals-3.6.1
	>=app-vim/genutils-1.13
	>=app-vim/foldutil-1.6"

VIM_PLUGIN_HELPTEXT=\
"This plugin allows breakpoints to be set and cleared visually. To start,
use :BreakPts, move to the required function and press <CR>. Breakpoints
can then be added using :BPToggle or <F9>."
