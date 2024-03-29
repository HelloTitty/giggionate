#!/bin/bash

is_alive_ping()
{
	ping -b -c 1 $1 > /dev/null
	[ $? -eq 0 ] && echo Node with IP: $i is up.
}


for i in 192.168.{1..255}.{1..255}
do
is_alive_ping $i & disown
done
