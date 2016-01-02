#!/bin/bash
url="http://YOUR_REMOTE_URL/get_topology.php"
token="YOUR_SHA1_TOKEN"
topology=$(/usr/bin/wget http://YOUR_GROUND_ROUTER_WITH_OLSR:2006 -q -O -)

/usr/bin/curl -X POST -d 'token='"$token"'&data='"$topology"'' $url
