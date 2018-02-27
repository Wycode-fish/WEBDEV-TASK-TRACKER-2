#!/bin/bash

export PORT=5400

cd ~/www/tracker2
./bin/task_tracker_2 stop || true
./bin/task_tracker_2 start

