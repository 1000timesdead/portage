# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/gems.eclass,v 1.25 2009/03/17 19:39:51 a3li Exp $

# @ECLASS: gems.eclass
# @MAINTAINER:
# ruby@gentoo.org
#
# Original Author: Rob Cakebread <pythonhead@gentoo.org>
#
# @BLURB: Eclass helping with the installation of RubyGems
# @DESCRIPTION:
# See http://dev.gentoo.org/~pythonhead/ruby/gems.html for notes on using gems with Portage.

# @ECLASS-VARIABLE: USE_RUBY
# @DESCRIPTION:
# Ruby versions the gem is compatible to. The eclass will install the gem for
# versions that are compatible and installed on the system. Format: rubyDD where
# DD is the two-digit version suffix (e.g.: USE_RUBY="ruby19" for Ruby 1.9.1)

inherit eutils ruby

SRC_URI="mirror://rubyforge/gems/${P}.gem"

IUSE="doc"

DEPEND="
	|| ( >=dev-ruby/rubygems-0.9.4 =dev-lang/ruby-1.9* )
	!dev-ruby/rdoc
"
RDEPEND="${DEPEND}"

# @FUNCTION: gems_location
# @USAGE: [Ruby binary]
# @DESCRIPTION:
# Exports GEMSDIR to the path Gems are installed to for the respective Ruby
# version
gems_location() {
	local ruby_version
	if [[ -z "$1" ]]; then
		ruby_version="gem"
	else
		ruby_version=${1/ruby/gem}
	fi
	export GEMSDIR=$(/usr/bin/${ruby_version} env gemdir)
}

# @FUNCTION: gems_src_unpack
# @DESCRIPTION:
# does nothing
gems_src_unpack() {
	true
}

# @FUNCTION: gems_src_compile
# @DESCRIPTION:
# does nothing
gems_src_compile() {
	true
}

# @FUNCTION: gems_src_install
# @DESCRIPTION: 
# Installs the gem
gems_src_install() {
	local myconf
	if use doc; then
		myconf="--rdoc --ri"
	else
		myconf="--no-rdoc --no-ri"
	fi

	# I'm not sure how many ebuilds have correctly set USE_RUBY - let's assume
	# ruby18 if they haven't, since even pure Ruby gems that have been written
	# against 1.8 can explode under 1.9.
	if [[ -z "${USE_RUBY}" ]]; then
		einfo "QA notice"
		einfo "The ebuild doesn't set USE_RUBY explicitly. Defaulting to ruby18."
		einfo "Please check compatibility and set USE_RUBY respectively."
		
		USE_RUBY="ruby18"
	elif [[ "${USE_RUBY}" == "any" ]]; then
		ewarn
		ewarn "DEPRECATION NOTICE"
		ewarn "USE_RUBY=\"any\" is deprecated. Please use explicit versions instead."
		ewarn "Support will be removed in April 2009."
		ewarn "For questions, please contact ruby@gentoo.org."
		ewarn

		# Get the installed versions.
		USE_RUBY=`ls /usr/bin/ruby* | grep -E 'ruby1(8|9)' | sed -e 's@/usr/bin/@@g'`
	fi

	local num_ruby_slots=$(echo "${USE_RUBY}" | wc -w)

	for ruby_version in ${USE_RUBY} ; do
		# Check that we have the version installed
		[[ -e "/usr/bin/${ruby_version/ruby/gem}" ]] || continue

		einfo "Installing for ${ruby_version}..."
		gems_location ${ruby_version}
		dodir ${GEMSDIR} || die

		if [[ -z "${MY_P}" ]]; then
			[[ -z "${GEM_SRC}" ]] && GEM_SRC="${DISTDIR}/${P}"
			spec_path="${D}/${GEMSDIR}/specifications/${P}.gemspec"
		else
			[[ -z "${GEM_SRC}" ]] && GEM_SRC="${DISTDIR}/${MY_P}"
			spec_path="${D}/${GEMSDIR}/specifications/${MY_P}.gemspec"
		fi

		# >=1.3.0 needs a path fix
		local gte13=$(/usr/bin/${ruby_version} -rubygems -e 'puts Gem::RubyGemsVersion >= "1.3.0"')

		if [[ "${gte13}" == "true" ]] ; then
			/usr/bin/${ruby_version} /usr/bin/gem install ${GEM_SRC} \
			--version ${PV} ${myconf} --local --install-dir "${D}/${GEMSDIR}" \
			--sandbox-fix --no-user-install || die "gem (>=1.3.0) install failed"
		else
			/usr/bin/${ruby_version} /usr/bin/gem install ${GEM_SRC} \
			--version ${PV} ${myconf} --local --install-dir "${D}/${GEMSDIR}" \
			|| die "gem (<1.3.0) install failed"
		fi

		if [[ -d "${D}/${GEMSDIR}/bin" ]] ; then
			exeinto /usr/bin
			for exe in "${D}"/${GEMSDIR}/bin/* ; do
				if [ "$num_ruby_slots" -ge 2 ] ; then
					# Ensures that the exe file gets run using the currently
					# selected version of ruby.
					sed -i -e 's@^#!/usr/bin/ruby.*$@#!/usr/bin/ruby@' "${exe}"
				fi
				doexe "${exe}" || die
			done
		fi
	done
}

EXPORT_FUNCTIONS src_unpack src_compile src_install
