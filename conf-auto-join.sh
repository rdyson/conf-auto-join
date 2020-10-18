#!/bin/bash

# Get the video conference URL from the calendar configured in gcalcli
conference_url()
{
 (/usr/local/bin/gcalcli agenda --details conference | grep -w "video:" | sed 's/^.*: //' | head -1)
}

# Check if the given URL is already open in Safari
is_url_open() {
 open_url=$(safari-ctl)
 conference_url=$1

 if [ "$open_url" = "$conference_url" ]; then
  return 1;
 else 
  return 0;
 fi
}

# Store values for the video conference URL and whether that URL is already open
conference_url=$(conference_url)
is_url_open "$conference_url"

# Store value returned from is_url_open (1 for true, 0 for false)
is_url_open_value=$?

# Open the video conference URL if it's not already open
if [ $is_url_open_value = 0 ]; then
 echo "Opening URL $conference_url"
 open -a "Safari.app" $conference_url
else
 echo "URL is already open, nothing to do with $conference_url"
fi

