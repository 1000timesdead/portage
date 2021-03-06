# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/regex-posix/regex-posix-0.72.0.3.ebuild,v 1.2 2010/07/01 19:58:56 jer Exp $

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal

DESCRIPTION="Replaces/Enhances Text.Regex"
HOMEPAGE="http://sourceforge.net/projects/lazy-regex"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-lang/ghc-6.6.1
		=dev-haskell/regex-base-0.7*"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.2"
