# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langmongolian/texlive-langmongolian-2009.ebuild,v 1.3 2010/02/02 21:21:55 abcd Exp $

TEXLIVE_MODULE_CONTENTS="hyphen-mongolian mongolian-babel montex soyombo collection-langmongolian
"
TEXLIVE_MODULE_DOC_CONTENTS="mongolian-babel.doc montex.doc soyombo.doc "
TEXLIVE_MODULE_SRC_CONTENTS="mongolian-babel.source "
inherit texlive-module
DESCRIPTION="TeXLive Mongolian"

LICENSE="GPL-2 as-is GPL-1 LPPL-1.3 "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2009
!=dev-texlive/texlive-langmanju-2007*
"
RDEPEND="${DEPEND} "
