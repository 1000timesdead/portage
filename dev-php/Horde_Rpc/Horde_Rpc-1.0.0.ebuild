# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/Horde_Rpc/Horde_Rpc-1.0.0.ebuild,v 1.2 2011/06/15 17:00:48 a3li Exp $

EAPI=4

inherit php-pear-r1

KEYWORDS="~amd64"
SLOT="0"
DESCRIPTION="Horde RPC API"
LICENSE="LGPL-2"
HOMEPAGE="http://www.horde.org/"
SRC_URI="http://pear.horde.org/get/${P}.tgz"

DEPEND=">=dev-lang/php-5.2.0
	>=dev-php/PEAR-PEAR-1.7.0
	=dev-php/Horde_ActiveSync-1*
	=dev-php/Horde_Core-1*
	=dev-php/Horde_Exception-1*
	=dev-php/Horde_Lock-1*
	=dev-php/Horde_Perms-1*
	=dev-php/Horde_Serialize-1*
	=dev-php/Horde_Support-1*
	=dev-php/Horde_SyncMl-1*
	=dev-php/Horde_Translation-1*
	=dev-php/Horde_Util-1*
	=dev-php/Horde_Xml_Element-1*"
RDEPEND="${DEPEND}"
