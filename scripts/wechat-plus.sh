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
BUNDLE_ID2="com.tencent.xinWeChat2"

ver() {
  /usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$1/Contents/Info.plist" 2>/dev/null
}

bid() {
  /usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "$1/Contents/Info.plist" 2>/dev/null
}

# Rebuild on version mismatch, and also when the bundle id is wrong --
# a previous rebuild may have copied the app but failed the plist edit.
if [ "$(ver "$APP")" != "$(ver "$APP2")" ] || [ "$(bid "$APP2")" != "$BUNDLE_ID2" ]; then
  echo "Rebuilding WeChat2.app from WeChat $(ver "$APP")..."
  rm -rf "$APP2"
  ditto "$APP" "$APP2" || { echo "ditto failed"; exit 1; }
  /usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $BUNDLE_ID2" "$APP2/Contents/Info.plist" || { echo "plist edit failed"; exit 1; }
  codesign --force --deep --sign - "$APP2" || { echo "codesign failed"; exit 1; }
  [ "$(bid "$APP2")" = "$BUNDLE_ID2" ] || { echo "bundle id verification failed"; exit 1; }
fi

open -g -a "$APP2"
