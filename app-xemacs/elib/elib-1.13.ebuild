# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/elib/elib-1.13.ebuild,v 1.3 2011/06/25 18:08:10 armin76 Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Portable Emacs Lisp utilities library."
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
"
KEYWORDS="alpha ~amd64 ~ppc ~ppc64 sparc x86"

inherit xemacs-packages
