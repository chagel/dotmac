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

# WeChat 4.x enforces a single instance via a lock in its sandbox container,
# which is keyed by bundle id -- so the second instance is a copy of the app
# with a different bundle id, giving it its own container, lock, and login.
# The copy is rebuilt whenever the real WeChat has been updated, since the
# ad-hoc re-sign has to be redone against the new binary anyway.

APP="/Applications/WeChat.app"
APP2="/Applications/WeChat2.app"

ver() {
  /usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$1/Contents/Info.plist" 2>/dev/null
}

if [ "$(ver "$APP")" != "$(ver "$APP2")" ]; then
  echo "Rebuilding WeChat2.app from WeChat $(ver "$APP")..."
  rm -rf "$APP2"
  ditto "$APP" "$APP2"
  /usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier com.tencent.xinWeChat2" "$APP2/Contents/Info.plist"
  codesign --force --deep --sign - "$APP2"
fi

open -g -a "$APP2"
