#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/5/18.

kill $(ps aux | grep '/usr/bin/java -cp burst.jar:conf nxt.Nxt' | awk '{print $2}')
kill $(ps aux | grep '/usr/bin/java -cp burst.jar:conf brs.Burst' | awk '{print $2}')
kill $(ps aux | grep '/bin/bash ./burst.sh' | awk '{print $2}')
