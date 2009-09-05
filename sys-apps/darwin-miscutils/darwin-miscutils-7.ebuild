# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/darwin-miscutils/darwin-miscutils-7.ebuild,v 1.2 2009/09/04 20:16:47 grobian Exp $

inherit toolchain-funcs eutils

MISC_VER=27
SHELL_VER=149
DEV_VER=52.1

DESCRIPTION="Miscellaneous commands used on Darwin/Mac OS X systems, Snow Leopard"
HOMEPAGE="http://www.opensource.apple.com/"
SRC_URI="http://www.opensource.apple.com/darwinsource/tarballs/other/misc_cmds-${MISC_VER}.tar.gz
	http://www.opensource.apple.com/darwinsource/tarballs/other/shell_cmds-${SHELL_VER}.tar.gz
	http://www.opensource.apple.com/darwinsource/tarballs/other/developer_cmds-${DEV_VER}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

S=${WORKDIR}

src_compile() {
	local flags=(
		${CFLAGS}
		-I.
		-D__FBSDID=__RCSID
		-Wsystem-headers
		${LDFLAGS}
	)

	local TS=${S}/misc_cmds-${MISC_VER}
	# tsort is provided by coreutils
	for t in leave units calendar; do
		cd "${TS}/${t}"
		echo "in ${TS}/${t}:"
		echo "$(tc-getCC) ${flags[@]} -o ${t}" *.c
		$(tc-getCC) ${flags[@]} -o ${t} *.c || die "failed to compile $t"
	done
	# compile cal separately
	cd "${TS}/ncal"
	echo "in ${TS}/ncal:"
	echo "$(tc-getCC) ${flags[@]} -c calendar.c"
	$(tc-getCC) ${flags[@]} -c calendar.c || die "failed to compile cal"
	echo "$(tc-getCC) ${flags[@]} -c easter.c"
	$(tc-getCC) ${flags[@]} -c easter.c || die "failed to compile cal"
	echo "$(tc-getCC) ${flags[@]} -c ncal.c"
	$(tc-getCC) ${flags[@]} -c ncal.c || die "failed to compile cal"
	echo "$(tc-getCC) ${flags[@]} -o cal calendar.o easter.o ncal.o"
	$(tc-getCC) ${flags[@]} -o cal calendar.o easter.o ncal.o || die "failed to compile cal"

	TS=${S}/shell_cmds-${SHELL_VER}
	# only pick those tools not provided by coreutils, findutils
	for t in \
		alias apply getopt hostname jot kill \
		lastcomm renice shlock time whereis;
	do
		echo "in ${TS}/${t}:"
		echo "$(tc-getCC) ${flags[@]} -o ${t} ${t}.c"
		cd "${TS}/${t}"
		$(tc-getCC) ${flags[@]} -o ${t} ${t}.c || die "failed to compile $t"
	done
	# script and killall need additonal flags
	for t in \
		killall script
	do
		echo "in ${TS}/${t}:"
		echo "$(tc-getCC) ${flags[@]} -o ${t} ${t}.c"
		cd "${TS}/${t}"
		$(tc-getCC) ${flags[@]} -o ${t} ${t}.c || die "failed to compile $t"
	done
	cd "${TS}/w"
	sed -i -e '/#include <libutil.h>/d' w.c || die
	echo "in ${TS}/w:"
	echo "$(tc-getCC) ${flags[@]} -DHAVE_UTMPX=1 -lresolv -o w w.c pr_time.c proc_compare.c"
	$(tc-getCC) ${flags[@]} -DHAVE_UTMPX=1 -lresolv -o w w.c pr_time.c proc_compare.c \
		|| die "failed to compile w"

	TS=${S}/developer_cmds-${DEV_VER}
	# only pick those tools that do not conflict (no ctags and indent)
	# do not install lorder, mkdep and vgrind as they are a non-prefix-aware
	# shell scripts
	# don't install rpcgen, as it is heavily related to the OS it runs
	# on (and this is the Leopard version)
	for t in asa error hexdump unifdef what ; do
		echo "in ${TS}/${t}:"
		cd "${TS}/${t}"
		echo "$(tc-getCC) ${flags[@]} -o ${t}" *.c
		$(tc-getCC) ${flags[@]} -o ${t} *.c || die "failed to compile $t"
	done
}

src_install() {
	[[ -z ${ED} ]] && local ED=${D}

	mkdir -p "${ED}"/bin
	mkdir -p "${ED}"/usr/bin

	local TS=${S}/misc_cmds-${MISC_VER}
	for t in leave units calendar ; do
		cp "${TS}/${t}/${t}" "${ED}"/usr/bin/
		doman "${TS}/${t}/${t}.1"
	done
	# copy cal separately
	cp "${TS}/ncal/cal" "${ED}"/usr/bin/
	dosym /usr/bin/cal /usr/bin/ncal
	doman "${TS}/ncal/ncal.1"
	dosym /usr/share/man/man1/ncal.1 /usr/share/man/man1/cal.1

	TS=${S}/shell_cmds-${SHELL_VER}
	for t in \
		alias apply getopt jot killall lastcomm \
		renice script shlock time w whereis;
	do
		cp "${TS}/${t}/${t}" "${ED}"/usr/bin/
		[[ -f "${TS}/${t}/${t}.1" ]] && doman "${TS}/${t}/${t}.1"
		[[ -f "${TS}/${t}/${t}.8" ]] && doman "${TS}/${t}/${t}.8"
	done
	cp "${TS}/w/w" "${ED}"/usr/bin/uptime
	doman "${TS}/w/uptime.1"
	for t in hostname kill; do
		cp "${TS}/${t}/${t}" "${ED}"/bin/
		doman "${TS}/${t}/${t}.1"
	done

	TS=${S}/developer_cmds-${DEV_VER}
	for t in asa error hexdump unifdef what ; do
		cp "${TS}/${t}/${t}" "${ED}"/usr/bin/
		doman "${TS}/${t}/${t}.1"
	done
}
