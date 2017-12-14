#!/bin/bash
passwd

status=$(echo $?)

while [ $status != 0 ];do
	passwd
	status=$(echo $?)
	break
done

echo "done"