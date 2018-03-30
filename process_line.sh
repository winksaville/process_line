#!/usr/bin/env bash
# sed: How to conditionally insert text multiple times in a single line?
#
# I have a pattern, "wink", which my appear zero or
# or more times on a line and I want to conditionally add
# my last name, "saville" if it isn't already present.

process_line () {
	# This replaces "wink" with "wink saville" unconditionally
	# How to make it conditional?
	echo $(sed -E 's/([[:space:]]*)wink([[:space:]]*)/\1wink saville\2/g' <<<"$@")
}

test_expect_success () {
	pattern=$1
	expect=$2
	result=$(process_line $pattern)
	if test "$result" = "$expect"; then
		echo -e "OK   with '$pattern'\n      got '$expect'"
	else
		echo -e "FAIL with '$pattern'\n expected '$expect'\n      was '$result'"
	fi
}

test_expect_success "wink" "wink saville"
test_expect_success "abc" "abc"
test_expect_success "wink wink" "wink saville wink saville"
test_expect_success "hi wink, yo wink" "hi wink saville, yo wink saville"
test_expect_success "wink saville wink" "wink saville wink saville"
test_expect_success "wink saville yo wink" "wink saville yo wink saville"
