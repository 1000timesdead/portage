# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/toggle/toggle-0.5.ebuild,v 1.2 2010/11/11 13:39:21 hwoarang Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: quickly toggle boolean-type keywords"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=895"
LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE=""

VIM_PLUGIN_HELPTEXT=\
"This plugin will toggle true/false, on/off, yes/no and so on when <C-T>
is pressed."
