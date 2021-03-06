# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/perl-i18n-langtags/perl-i18n-langtags-0.35.ebuild,v 1.6 2011/06/28 19:55:09 tove Exp $

DESCRIPTION="Virtual for I18N-LangTags"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND="|| ( ~dev-lang/perl-5.12.4 ~dev-lang/perl-5.12.3 ~dev-lang/perl-5.12.2 ~dev-lang/perl-5.10.1 ~dev-lang/perl-5.8.8 ~perl-core/i18n-langtags-${PV} )"
