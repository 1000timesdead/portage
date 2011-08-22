# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/eclass-manpages/files/eclass-to-manpage.awk,v 1.24 2011/08/22 04:49:21 vapier Exp $

# This awk converts the comment documentation found in eclasses
# into man pages for easier/nicer reading.
#
# If you wish to have multiple paragraphs in a description, then
# create empty comment lines.  Paragraph parsing ends when the comment
# block does.
#
# The format of the eclass description:
# @ECLASS: foo.eclass
# @MAINTAINER:
# <required; list of contacts, one per line>
# @AUTHOR:
# <optional; list of authors, one per line>
# @BLURB: <required; short description>
# @DESCRIPTION:
# <optional; long description>
# @EXAMPLE:
# <optional; example usage>

# The format of functions:
# @FUNCTION: foo
# @USAGE: <required arguments to foo> [optional arguments to foo]
# @RETURN: <whatever foo returns>
# @MAINTAINER:
# <optional; list of contacts, one per line>
# [@INTERNAL]
# @DESCRIPTION:
# <required if no @RETURN; blurb about this function>

# The format of function-specific variables:
# @VARIABLE: foo
# [@DEFAULT_UNSET]
# [@INTERNAL]
# [@REQUIRED]
# @DESCRIPTION:
# <required; blurb about this variable>
# foo="<default value>"

# The format of eclass variables:
# @ECLASS-VARIABLE: foo
# [@DEFAULT_UNSET]
# [@INTERNAL]
# [@REQUIRED]
# @DESCRIPTION:
# <required; blurb about this variable>
# foo="<default value>"

# Common features:
# @CODE
# In multiline paragraphs, you can create chunks of unformatted
# code by using this marker at the start and end.
# @CODE

function _stderr_msg(text, type,   file, cnt) {
	if (_stderr_header_done != 1) {
		cnt = split(FILENAME, file, /\//)
		print "\n" file[cnt] ":" > "/dev/stderr"
		_stderr_header_done = 1
	}

	print "   " type ":" NR ": " text > "/dev/stderr"
}
function warn(text) {
	_stderr_msg(text, "warning")
}
function fail(text) {
	_stderr_msg(text, "error")
	exit(1)
}

function eat_line() {
	ret = $0
	sub(/^# @[A-Z]*:[[:space:]]*/,"",ret)
	getline
	return ret
}
function eat_paragraph() {
	code = 0
	ret = ""
	getline
	while ($0 ~ /^#([[:space:]]*$|[[:space:]][^@])/) {
		sub(/^#[[:space:]]?/, "", $0)
		ret = ret "\n" $0
		# Handle the common case of trailing backslashes in
		# code blocks to cross multiple lines #335702
		if (code && $NF == "\\")
			ret = ret "\\"
		getline
		if ($0 ~ /^# @CODE$/) {
			if (code)
				ret = ret "\n.fi"
			else
				ret = ret "\n.nf"
			code = !code
			getline
		}
	}
	sub(/^\n/,"",ret)
	return ret
}

function pre_text(p) {
	return ".nf\n" p "\n.fi"
}

function man_text(p) {
	return gensub(/-/, "\\-", "g", p)
}

#
# Handle an @ECLASS block
#
function handle_eclass() {
	eclass = $3
	eclass_maintainer = ""
	eclass_author = ""
	blurb = ""
	desc = ""
	example = ""

	# first the man page header
	print ".\\\" -*- coding: utf-8 -*-"
	print ".\\\" ### DO NOT EDIT THIS FILE"
	print ".\\\" ### This man page is autogenerated by eclass-to-manpage.awk"
	print ".\\\" ### based on comments found in " eclass
	print ".\\\""
	print ".\\\" See eclass-to-manpage.awk for documentation on how to get"
	print ".\\\" your eclass nicely documented as well."
	print ".\\\""
	print ".TH \"" toupper(eclass) "\" 5 \"" strftime("%b %Y") "\" \"Portage\" \"portage\""

	# now eat the global data
	getline
	if ($2 == "@MAINTAINER:")
		eclass_maintainer = eat_paragraph()
	if ($2 == "@AUTHOR:")
		eclass_author = eat_paragraph()
	if ($2 == "@BLURB:")
		blurb = eat_line()
	if ($2 == "@DESCRIPTION:")
		desc = eat_paragraph()
	if ($2 == "@EXAMPLE:")
		example = eat_paragraph()

	# finally display it
	print ".SH \"NAME\""
	print eclass " \\- " man_text(blurb)
	if (desc != "") {
		print ".SH \"DESCRIPTION\""
		print man_text(desc)
	}
	if (example != "") {
		print ".SH \"EXAMPLE\""
		print man_text(example)
	}

	# sanity checks
	if (blurb == "")
		fail(eclass ": no @BLURB found")
	if (eclass_maintainer == "")
		warn(eclass ": no @MAINTAINER found")
}

#
# Handle a @FUNCTION block
#
function show_function_header() {
	if (_function_header_done != 1) {
		print ".SH \"FUNCTIONS\""
		_function_header_done = 1
	}
}
function handle_function() {
	func_name = $3
	usage = ""
	funcret = ""
	maintainer = ""
	internal = 0
	desc = ""

	# grab the docs
	getline
	if ($2 == "@USAGE:")
		usage = eat_line()
	if ($2 == "@RETURN:")
		funcret = eat_line()
	if ($2 == "@MAINTAINER:")
		maintainer = eat_paragraph()
	if ($2 == "@INTERNAL") {
		internal = 1
		getline
	}
	if ($2 == "@DESCRIPTION:")
		desc = eat_paragraph()

	if (internal == 1)
		return

	show_function_header()

	# now print out the stuff
	print ".TP"
	print "\\fB" func_name "\\fR " man_text(usage)
	if (desc != "")
		print man_text(desc)
	if (funcret != "") {
		if (desc != "")
			print ""
		print "Return value: " funcret
	}

	if (blurb == "")
		fail(func_name ": no @BLURB found")
	if (desc == "" && funcret == "")
		fail(func_name ": no @DESCRIPTION found")
}

#
# Handle @VARIABLE and @ECLASS-VARIABLE blocks
#
function _handle_variable() {
	var_name = $3
	desc = ""
	val = ""
	default_unset = 0
	internal = 0
	required = 0

	# grab the optional attributes
	opts = 1
	while (opts) {
		getline
		if ($2 == "@DEFAULT_UNSET")
			default_unset = 1
		else if ($2 == "@INTERNAL")
			internal = 1
		else if ($2 == "@REQUIRED")
			required = 1
		else
			opts = 0
	}
	if ($2 == "@DESCRIPTION:")
		desc = eat_paragraph()

	# extract the default variable value
	# first try var="val"
	op = "="
	regex = "^.*" var_name "=(.*)$"
	val = gensub(regex, "\\1", "", $0)
	if (val == $0) {
		# next try : ${var:=val}
		op = "?="
		regex = "^[[:space:]]*:[[:space:]]*[$]{" var_name ":?=(.*)}"
		val = gensub(regex, "\\1", "", $0)
		if (val == $0) {
			if (default_unset + required + internal == 0)
				warn(var_name ": unable to extract default variable content: " $0)
			val = ""
		} else if (val !~ /^["']/ && val ~ / /) {
			if (default_unset == 1)
				warn(var_name ": marked as unset, but has value: " val)
			val = "\"" val "\""
		}
	}
	if (length(val))
		val = " " op " \\fI" val "\\fR"
	if (required == 1)
		val = val " (REQUIRED)"

	if (internal == 1)
		return ""

	# now accumulate the stuff
	ret = \
		".TP" "\n" \
		"\\fB" var_name "\\fR" val "\n" \
		man_text(desc)

	if (desc == "")
		fail(var_name ": no @DESCRIPTION found")

	return ret
}
function handle_variable() {
	show_function_header()
	ret = _handle_variable()
	if (ret == "")
		return
	print ret
}
function handle_eclass_variable() {
	ret = _handle_variable()
	if (ret == "")
		return
	if (eclass_variables != "")
		eclass_variables = eclass_variables "\n"
	eclass_variables = eclass_variables ret
}

#
# Spit out the common footer of manpage
#
function handle_footer() {
	if (eclass_variables != "") {
		print ".SH \"ECLASS VARIABLES\""
		print man_text(eclass_variables)
	}
	if (eclass_author != "") {
		print ".SH \"AUTHORS\""
		print pre_text(man_text(eclass_author))
	}
	if (eclass_maintainer != "") {
		print ".SH \"MAINTAINERS\""
		print pre_text(man_text(eclass_maintainer))
	}
	print ".SH \"REPORTING BUGS\""
	print "Please report bugs via http://bugs.gentoo.org/"
	print ".SH \"FILES\""
	print ".BR " eclassdir "/" eclass
	print ".SH \"SEE ALSO\""
	print ".BR ebuild (5)"
	print pre_text("http://sources.gentoo.org/eclass/" eclass "?view=log")
}

#
# Init parser
#
BEGIN {
	state = "header"
	if (PORTDIR == "")
		PORTDIR = "/usr/portage"
	eclassdir = PORTDIR "/eclass"
}

#
# Main parsing routine
#
{
	if (state == "header") {
		if ($0 ~ /^# @ECLASS:/) {
			handle_eclass()
			state = "funcvar"
		} else if ($0 == "# @DEAD") {
			eclass = "dead"
			exit(10)
		} else if ($0 == "# @eclass-begin") {
			fail("java documentation not supported")
		} else if ($0 ~ /^# @/)
			warn("Unexpected tag in \"" state "\" state: " $0)
	} else if (state == "funcvar") {
		if ($0 ~ /^# @FUNCTION:/)
			handle_function()
		else if ($0 ~ /^# @VARIABLE:/)
			handle_variable()
		else if ($0 ~ /^# @ECLASS-VARIABLE:/)
			handle_eclass_variable()
		else if ($0 ~ /^# @/)
			warn("Unexpected tag in \"" state "\" state: " $0)
	}
}

#
# Tail end
#
END {
	if (eclass == "")
		fail("eclass not documented yet (no @ECLASS found)")
	else if (eclass != "dead")
		handle_footer()
}
