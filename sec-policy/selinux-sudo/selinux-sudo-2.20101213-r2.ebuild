# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-sudo/selinux-sudo-2.20101213-r2.ebuild,v 1.2 2011/06/02 13:00:44 blueness Exp $

MODS="sudo"
IUSE=""

inherit selinux-policy-2

DESCRIPTION="SELinux policy for sudo"

KEYWORDS="amd64 x86"

RDEPEND=">=sec-policy/selinux-base-policy-2.20101213-r8"
