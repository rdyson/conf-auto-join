#!/bin/bash

# Get the video conference URL from the calendar configured in gcalcli
conference_url()
{
 (/usr/local/bin/gcalcli agenda --nostarted --nodeclined --details conference $1 $2 | grep -w "video:" | sed 's/^.*: //' | head -1)
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

# Check if a conference app is running (Zoom)
is_conf_app_running() {
 if ps ax | grep -v grep | grep zoom > /dev/null; then
  return 1;
 else
  return 0;
 fi
}

# Store values for time range to search
range_start=$(date +"%H%M")
range_end=$(date -v +5M +"%H%M")

# Store values for the video conference URL and whether that URL is already open
conference_url_value=$(conference_url "$range_start $range_end")

# Get and store value returned from is_url_open (1 for true, 0 for false)
is_url_open "$conference_url_value"
is_url_open_value=$?

# Get and store value returned from is_conf_app_running (1 for true, 0 for false)
is_conf_app_running
is_conf_app_running_value=$?

# Open the video conference URL if there is one, if it's not already open and a conference app is not already running
if [[ -n $conference_url_value ]] && [ $is_url_open_value = 0 ] && [ $is_conf_app_running_value = 0 ]; then
 echo "Opening URL $conference_url_value"
 open -a "Safari.app" $conference_url_value
else
 echo "URL is already open, conference app already running, or there's no upcoming event. Nothing to do. $conference_url_value"
fi

