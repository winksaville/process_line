#!/usr/bin/env bash
sed -E '/([[:space:]]*)bdl([[:space:]]+)(slo@=[[:digit:]]+)|([[:space:]]*)bdl$/ { s/bdl/abc/ }' <<<"$@"
