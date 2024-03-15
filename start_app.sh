#!/bin/sh

/usr/local/bin/srt-live-transmit -st:yes "srt://127.0.0.1:5002?mode=listener&lossmaxttl=40&latency=2000" "srt://0.0.0.0:5001?mode=listener" -v &
sleep 5
/usr/local/bin/srtla_rec 5000 127.0.0.1 5002