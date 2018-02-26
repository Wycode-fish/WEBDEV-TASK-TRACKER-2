#!/bin/bash

export PORT=5301

cd ~/www/tracker2
./bin/task_tracker stop || true
./bin/task_tracker start

