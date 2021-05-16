#!/usr/bin/env bash
#
# This is a script to automate launching various servers that I want to be
# active on themathjester, so that, even after I reboot, I'll only have to run
# one master script to set everything back up. 빨리 빨리!
#

# Begin the IRC server (TODO give it a SSL cert for authentication?)
/var/www/irc/inspircd-3.9.0/run/bin/inspircd start --nofork &

# Begin the gemini server, with the SSL cert
sudo -u gemini /home/gemini/bin/agate --content /var/www/gemini/ --key /home/gemini/bin/gemini-self-signed.rsa --cert /home/gemini/bin/cert.pem --addr [::]:1965 --addr 0.0.0.0:1965 --hostname themathjester.com --lang en-US 2>~/gemini-log.txt &

