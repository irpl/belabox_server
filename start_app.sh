#!/bin/bash

/usr/local/bin/srt/srt-live-transmit -st:yes "srt://127.0.0.1:5002?mode=listener&lossmaxttl=40&latency=2000" "srt://0.0.0.0:5001?mode=listener" -v
/usr/local/bin/srtla/srtla_rec 5000 127.0.0.1 5002