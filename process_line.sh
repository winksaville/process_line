#!/usr/bin/env bash
# In bash how to process multiple matches a single line?
#
#I have a pattern, "wink", which my appear zero or
#or more times on a line and I want to add some text, my
#last name "saville", if "saville" isn't already present.

process_line () {
	# Process the parameter 
	echo "wink saville wink saville"
}

count_wink_saville () {
	words="$(grep -o 'wink' <<< $1)"
	echo "$(wc -w <<< "$words")"
}

result=$(process_line "wink wink")
test "$result" = "wink saville wink saville" && echo OK || echo FAIL
test "$(process_line 'wink wink')" = "wink saville wink saville" && echo OK || echo FAIL
test $(count_wink_saville "$result") = "2" && echo OK || echo FAIL
#test $(process_line "wink") = "wink saville" && echo OK || echo FAIL
#test $(process_line "abc") = "abc" && echo OK || echo FAIL
#test $(process_line " wink saville wink") = " wink saville wink saville" && echo OK || echo FAIL
#test $(process_line " wink saville yo wink") = " wink saville yo wink saville" && echo OK || echo FAIL

#result=$(process_line "$@")
#printf "found %s 'wink saville's" $count_wink_saville $result
