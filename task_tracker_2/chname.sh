#!/bin/bash

set -e

CURRENT_NAME="TaskTracker2"
CURRENT_OTP="task_tracker"

NEW_NAME="TaskTracker2"
NEW_OTP="task_tracker_2"

ack -l $CURRENT_NAME | xargs sed -i '' -e "s/$CURRENT_NAME/$NEW_NAME/g"
ack -l $CURRENT_OTP | xargs sed -i '' -e "s/$CURRENT_OTP/$NEW_OTP/g"

mv lib/$CURRENT_OTP lib/$NEW_OTP
mv lib/$CURRENT_OTP.ex lib/$NEW_OTP.ex
mv lib/${CURRENT_OTP}_web lib/${NEW_OTP}_web
mv lib/${CURRENT_OTP}_web.ex lib/${NEW_OTP}_web.ex
