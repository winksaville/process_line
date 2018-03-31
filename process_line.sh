#!/usr/bin/env bash
# sed: How to conditionally insert text multiple times in a single line?
#
# I have a pattern, "wink", which my appear zero or
# or more times on a line and I want to conditionally add
# my last name, "saville" if it isn't already present.

process_line () {
	# Simplest solution I could figure out
	echo $(sed -E 's/\bwink\b|\bwink saville\b/wink saville/g' <<<"$@")

	# Also using 'vim' style with \< and \> for beginning/end word boundaries
	#echo $(sed -E 's/\<wink\>|\<wink saville\>/wink saville/g' <<<"$@")

	# From [1] \b is an anchor like BOL ^ and EOL $ and is zero length
	# so it captures nothing and this makes no difference:
	#echo $(sed -E 's/(\b)wink(\b)|(\b)wink saville(\b)/\1\1wink saville\2\2/g' <<<"$@")

	# Attempt to simulate "g" with loops, isn't working why?
	# $!btop is from [2] and says branch to top if not EOL.
	#echo $(sed -E '{ : top ; s/\bwink\b/wink saville/ ; $!btop } ' <<<"$@")

# Footnotes
# [1]: https://www.regular-expressions.info/wordboundaries.html
# [2]: https://stackoverflow.com/questions/1251999/how-can-i-replace-a-newline-n-using-sed
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
test_expect_success "wink   wink" "wink saville wink saville"
test_expect_success "wink saville" "wink saville"
test_expect_success "hi wink, yo wink" "hi wink saville, yo wink saville"
test_expect_success "wink saville wink" "wink saville wink saville"
test_expect_success "wink saville yo wink" "wink saville yo wink saville"
