#!/bin/bash

export PORT=5400
export MIX_ENV=prod
export GIT_PATH=/home/tracker2/src/task_tracker_2

PWD=`pwd`
if [ $PWD != $GIT_PATH ]; then
	echo "Error: Must check out git repo to $GIT_PATH"
	echo "  Current directory is $PWD"
	exit 1
fi

if [ $USER != "tracker2" ]; then
	echo "Error: must run as user 'tracker2'"
	echo "  Current user is $USER"
	exit 2
fi

mix deps.get
(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)
mix phx.digest
mix release --env=prod

mkdir -p ~/www
mkdir -p ~/old

NOW=`date +%s`
if [ -d ~/www/tracker ]; then
	echo mv ~/www/tracker2 ~/old/$NOW
	mv ~/www/tracker2 ~/old/$NOW
fi

mkdir -p ~/www/tracker2
REL_TAR=~/src/task_tracker_2/_build/prod/rel/task_tracker_2/releases/0.0.1/task_tracker_2.tar.gz
(cd ~/www/tracker2 && tar xzvf $REL_TAR)

crontab - <<CRONTAB
@reboot bash /home/tracker2/src/task_tracker_2/start.sh
CRONTAB

#. start.sh
