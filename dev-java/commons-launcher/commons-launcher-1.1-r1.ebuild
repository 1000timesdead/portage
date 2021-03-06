# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-launcher/commons-launcher-1.1-r1.ebuild,v 1.5 2008/03/18 01:18:09 betelgeuse Exp $

JAVA_PKG_IUSE="examples doc source"

inherit base java-pkg-2 java-ant-2

DESCRIPTION="Commons-launcher eliminates the need for a batch or shell script to launch a Java class."
HOMEPAGE="http://jakarta.apache.org/commons/launcher/"
SRC_URI="mirror://apache/jakarta/${PN/-//}/source/${P}-src.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86 ~x86-fbsd"

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4
	dev-java/ant-core"

S=${WORKDIR}/${PN}

# https://issues.apache.org/jira/browse/LAUNCHER-7
PATCHES=( "${FILESDIR}/1.1-javadoc.patch" )

src_compile() {
	java-ant_rewrite-classpath "${S}/build.xml"
	EANT_GENTOO_CLASSPATH="ant-core" java-pkg-2_src_compile
}

# Standard commons build.xml but no tests actually implemented
src_test() { :; }

src_install() {
	java-pkg_dojar dist/bin/*.jar || die "java-pkg_dojar died"
	dodoc README.txt NOTICE.txt || die
	use doc && java-pkg_dojavadoc dist/docs/api
	use examples && java-pkg_doexamples example
	use source && java-pkg_dosrc src/java/*
}
