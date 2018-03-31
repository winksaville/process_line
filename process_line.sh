#!/usr/bin/env bash
# sed: How to conditionally insert text multiple times in a single line?
#
# I have a pattern, "wink", which my appear zero or
# or more times on a line and I want to conditionally add
# my last name, "saville" if it isn't already present.

process_line () {
	# This replaces "wink" with "wink saville" unconditionally
	# Working OK except "wink wink" should work and it doesn'!
	echo $(sed -E 's/(\W+|^)(wink)(\W+|$)/\1\2 saville\3/g' <<<"$@")

	# Attempt to simulate "g" with loops, isn't working why?
	# $!btop is from [1] and says branch to top if not EOL.
	#echo $(sed -E '{ : top ; s/(\W+|^)(wink)(\W+|$)/\1\2 saville\3/ ; $!btop } ' <<<"$@")

	# Here's an attempt that conditionally handles
	# "wink" or "wink saville" once, but isn't looping
	# properly.
	#echo $(sed -E '{ : top ; s/(\W+|^)(wink)(\W+)(saville)(\W+|$)/\1\2\3\4\5/ ; t btm ; s/(\W+|^)(wink)(\W+|$)/\1\2 saville\3/ ; : btm ; $!btop }' <<<"$@")

	# Footnotes
	# [1]: https://stackoverflow.com/questions/1251999/how-can-i-replace-a-newline-n-using-sed
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

test_expect_success "abc" "abc"
test_expect_success "wink" "wink saville"
test_expect_success "winkwink" "winkwink"
test_expect_success "ywink" "ywink"
test_expect_success "winkyo" "winkyo"
test_expect_success "winkyo winks" "winkyo winks"
test_expect_success "yowink swink" "yowink swink"
test_expect_success "yowink winks" "yowink winks"
test_expect_success "yowink wink" "yowink wink saville"
test_expect_success "wink winkyo" "wink saville winkyo"
test_expect_success "wink wink" "wink saville wink saville"
test_expect_success "wink saville" "wink saville"
test_expect_success "hi wink, yo wink" "hi wink saville, yo wink saville"
test_expect_success "wink saville wink" "wink saville wink saville"
test_expect_success "wink saville yo wink" "wink saville yo wink saville"
