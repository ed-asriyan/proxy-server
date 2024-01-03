#!/bin/sh

# https://www.instructables.com/Quick-and-Dirty-Dynamic-DNS-Using-GoDaddy

domain=$1
record=$2
api_key=$3

myip=`curl -s "https://api.ipify.org"`
dnsdata=`curl -s -X GET -H "Authorization: sso-key ${api_key}" "https://api.godaddy.com/v1/domains/${domain}/records/A/${record}"`
gdip=`echo $dnsdata | cut -d ',' -f 1 | tr -d '"' | cut -d ":" -f 2`
echo "Current External IP is $myip"
echo "GoDaddy DNS IP is      $gdip"

if [ "$gdip" != "$myip" -a "$myip" != "" ]; then
  echo "IP has changed!! Updating on GoDaddy"
  curl -s -X PUT "https://api.godaddy.com/v1/domains/${domain}/records/A/${record}" -H "Authorization: sso-key ${api_key}" -H "Content-Type: application/json" -d "[{\"data\": \"${myip}\"}]"
  echo "Changed IP on ${hostname}.${domain} from ${gdip} to ${myip}"
fi
