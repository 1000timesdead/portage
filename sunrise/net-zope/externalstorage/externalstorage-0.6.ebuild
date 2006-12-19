# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit zproduct

DESCRIPTION="Plone add-on product which provides an extra storage for Archetypes."
HOMEPAGE="http://plone.org/products/externalstorage/"
SRC_URI="http://plone.org/products/externalstorage/releases/${PV}/ExternalStorage-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

RDEPEND=">=net-zope/archetypes-1.3.4"

ZPROD_LIST="ExternalStorage"

S="${S}/ExternalStorage-${PV}"

src_install() {
	zproduct_src_install all
}
