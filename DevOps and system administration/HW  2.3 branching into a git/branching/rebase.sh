#!/bin/bash
# display command line options
#повторный коммит echo "Next parameter: $param"

count=1
for param in "$@"; do
    echo "\$@ Parameter #$count = $param"
    echo "Next parameter: $param"

    count=$(( $count + 1 ))
done

echo "====="