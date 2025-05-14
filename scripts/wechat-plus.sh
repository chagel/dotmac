#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title WeChat+
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName us.gchen.wechat

# Documentation:
# @raycast.description Start another WeChat instance
# @raycast.author MGC

nohup /Applications/WeChat\ 3.app/Contents/MacOS/WeChat> /dev/null 2>&1 &
