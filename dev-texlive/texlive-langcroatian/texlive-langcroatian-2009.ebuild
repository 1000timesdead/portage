# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langcroatian/texlive-langcroatian-2009.ebuild,v 1.3 2010/02/02 21:14:31 abcd Exp $

TEXLIVE_MODULE_CONTENTS="croatian hrlatex hyphen-croatian collection-langcroatian
"
TEXLIVE_MODULE_DOC_CONTENTS="croatian.doc hrlatex.doc "
TEXLIVE_MODULE_SRC_CONTENTS="hrlatex.source "
inherit texlive-module
DESCRIPTION="TeXLive Croatian"

LICENSE="GPL-2 as-is LPPL-1.3 "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2009
"
RDEPEND="${DEPEND} "
