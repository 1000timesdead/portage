# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kdesudo/kdesudo-3.4.2.3.ebuild,v 1.1 2010/01/27 20:18:48 ssuominen Exp $

EAPI=2
# FIXME. What is linguas_jv, different Japanese translation?
KDE_LINGUAS="ar cs da de el en_GB es et fa fi fr gl he hr hu id is it ja kk ko
lt lv ms nb nl oc pl pt pt_BR ro ru sk sv tl tr uk zh_CN zh_TW"
inherit kde4-base

DESCRIPTION="A frontend for sudo. Unlike kdesu, it uses directly sudo as backend."
HOMEPAGE="http://launchpad.net/kdesudo/"
SRC_URI="http://launchpad.net/${PN}/3.x/${PV}/+download/${P}.tar.gz"

LICENSE="FDL-1.2 GPL-2 LGPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug +handbook"

RDEPEND="app-admin/sudo"

DOCS="AUTHORS ChangeLog README"
