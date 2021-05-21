#!/usr/bin/env bash
# 
# Scrambles the DIRECTORY NAME of the COA Web Edition, so that
# nominally, only chocorho himself has immediate access to it,
# and those wishing to test it will need to contact him.
# 
# As of Feb. 2021, this script is scheduled to run
# ONCE PER DAY.
# 

set -o errexit

# get directory name strings
oldname=`head -n 1 ~/current-mgg-dir.txt`
newname=`strings /dev/urandom | head -n 1`
recipient="$1@mms.att.net"

echo "Read the old URL as "$oldname
echo "/var/www/html/$oldname"

if [ -L "/var/www/html/$newname" ]; then
  rm -f "/var/www/html/$newname";
fi

# update the directory name
mv   "/var/www/html/$oldname" "/var/www/html/$newname"
mv   "/var/www/html/$newname/hashover/pages/$oldname-comment-html" "/var/www/html/$newname/hashover/pages/$newname-comment-html"
ln -s /var/www/html/old.html  "/var/www/html/$oldname"

# encode the string as a URL, print output and overwrite the log file storing it
# (note, requires bash 4 and above!)
# TODO -- if $newname contains a `$`, do we need to escape it?
declare -A encoding=( ['#']='%23' ['$']='%24' ['%']='%25' ['&']='%26' \
                      ['+']='%2B' [',']='%2C' ['/']='%2F' [':']='%3A' \
                      [';']='%3B' ['=']='%3D' ['?']='%3F' ['@']='%40' \
                      ['\"']='%22' ['<']='%3C' ['>']='%3E' ['`']='%60' \
                      ['{']='%7B' ['}']='%7D' ['|']='%7C' \
                      ['\\']='%5C' ['^']='%5E' ['~']='%7E' \
                      ['[']='%5B' [']']='%5D' [' ']='%20' )

encoded_url=""
index=0
upper=${#newname}

while (( $index < $upper )); do
  val=${encoding[${newname:$index:1}]}
  if [[ "$val" == "" ]]; then
    encoded_url=$encoded_url${newname:$index:1}
  else
    encoded_url=$encoded_url$val
  fi
  index=$(( index + 1 ))
#  index=`expr $index + 1`
done

echo "$newname" | tee ~/current-mgg-dir.txt

# An older, slower method used a python script to encode the string:
#encoded_url=$(echo "$newname" | ~/scripts/encode-url.py)

echo "Changing name to: https://www.themathjester.com/$encoded_url" | mail -s "New MGG URL" $recipient

