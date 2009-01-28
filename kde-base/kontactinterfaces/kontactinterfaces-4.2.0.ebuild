# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kontactinterfaces/kontactinterfaces-4.2.0.ebuild,v 1.1 2009/01/27 17:38:24 alexxy Exp $

EAPI="2"

KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="Interfaces for Kontact"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="kde-base/libkdepim:${SLOT}"

KMSAVELIBS="true"
KMEXTRACTONLY="kaddressbook/org.kde.KAddressbook.Core.xml
			korganizer/korgac/org.kde.korganizer.KOrgac.xml"
KMCOMPILEONLY="libkdepim"