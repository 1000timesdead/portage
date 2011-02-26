# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/lmms/lmms-0.4.9-r2.ebuild,v 1.1 2011/02/26 15:09:52 aballier Exp $

EAPI="2"

inherit eutils cmake-utils

DESCRIPTION="free alternative to popular programs such as Fruityloops, Cubase and Logic"
HOMEPAGE="http://lmms.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="alsa debug fftw fluidsynth jack ogg pulseaudio sdl stk vst"

RDEPEND="x11-libs/qt-core:4
	x11-libs/qt-gui:4[accessibility]
	>=media-libs/libsndfile-1.0.11
	>=media-libs/libsamplerate-0.1.7
	x11-libs/libXinerama
	alsa? ( media-libs/alsa-lib )
	fftw? ( =sci-libs/fftw-3* >=x11-libs/fltk-1.3.0_rc:1.1 )
	jack? ( >=media-sound/jack-audio-connection-kit-0.99.0 )
	ogg? ( media-libs/libvorbis
			media-libs/libogg )
	fluidsynth? ( media-sound/fluidsynth )
	pulseaudio? ( media-sound/pulseaudio )
	sdl? ( media-libs/libsdl
			>=media-libs/sdl-sound-1.0.1 )
	stk? ( media-libs/stk )
	vst? ( app-emulation/wine )"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.5"
RDEPEND="${RDEPEND}
	media-plugins/swh-plugins
	media-plugins/caps-plugins
	media-plugins/tap-plugins"

DOCS="README AUTHORS TODO"

PATCHES=( "${FILESDIR}/${PN}-unembedfltk.patch" )
src_configure() {
	mycmakeargs="${mycmakeargs}
		-DWANT_SYSTEM_SR=TRUE
		-DWANT_CAPS=FALSE
		-DWANT_TAP=FALSE
		-DWANT_SWH=FALSE
		-DWANT_CMT=TRUE
		-DWANT_CALF=TRUE
		$(cmake-utils_use_want alsa ALSA)
		$(cmake-utils_use_want fftw FFTW3F)
		$(cmake-utils_use_want jack JACK)
		$(cmake-utils_use_want ogg OGGVORBIS)
		$(cmake-utils_use_want pulseaudio PULSEAUDIO)
		$(cmake-utils_use_want sdl SDL)
		$(cmake-utils_use_want stk STK)
		$(cmake-utils_use_want vst VST)
		$(cmake-utils_use_want fluidsynth SF2)"
	cmake-utils_src_configure
}
