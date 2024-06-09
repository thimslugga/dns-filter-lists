#!/bin/bash

URL="https://support.apple.com/en-us/HT210060"

# Check if the URL is reachable
if ! curl -s -I -X GET "${URL}" | grep "200 OK" > /dev/null; then
  echo "URL is not reachable"
  exit 1
fi

test -f ./domains.txt \
  && rm -f ./domains.txt

# Fetch the webpage content
content="$(curl -sL $URL)"

# Parse domains from the content
domains=$(echo "${content}" | grep -oP '(?<=://)[a-zA-Z0-9.-]+' | sort | uniq)

# Print the parsed domains
#echo "$domains"

# Print the parsed domains
echo "${domains}" > ./domains.txt

#ls -ltr ./*.txt
