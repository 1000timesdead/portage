# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/plasma-runtime/plasma-runtime-4.6.3.ebuild,v 1.2 2011/06/08 23:40:48 tomka Exp $

EAPI=4

KMNAME="kdebase-runtime"
KMMODULE="plasma"
DECLARATIVE_REQUIRED="always"
inherit kde4-meta

DESCRIPTION="Script engine and package tool for plasma"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug"

# cloned from workspace thus introduce collisions.
add_blocker plasma-workspace '<4.5.60'
add_blocker kdelibs '<4.5.60'
