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

# WeChat 4.x enforces a single instance via a lock in its data container,
# which it derives from the bundle id -- so the second instance is a copy of
# the app with a different bundle id, giving it its own container, lock, and
# login. The copy is rebuilt whenever the real WeChat has been updated, since
# the ad-hoc re-sign has to be redone against the new binary anyway.
#
# The copy must not self-update: Sparkle replaces the bundle in place with a
# pristine WeChat.app (original bundle id), which then squats on the main
# container at next launch. So the Sparkle installer is stripped from the copy
# and silent auto-install is disabled in its defaults domain.

APP="/Applications/WeChat.app"
APP2="/Applications/WeChat2.app"
BUNDLE_ID2="com.tencent.xinWeChat2"
SPARKLE2="$APP2/Contents/Frameworks/Sparkle.framework/Versions/Current"

ver() {
  /usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$1/Contents/Info.plist" 2>/dev/null
}

bid() {
  /usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "$1/Contents/Info.plist" 2>/dev/null
}

# Rebuild on version mismatch, wrong bundle id (a self-update or failed plist
# edit restored the original), or an intact Sparkle installer (old build).
if [ "$(ver "$APP")" != "$(ver "$APP2")" ] || [ "$(bid "$APP2")" != "$BUNDLE_ID2" ] || [ -e "$SPARKLE2/Autoupdate" ]; then
  echo "Rebuilding WeChat2.app from WeChat $(ver "$APP")..."
  # A stale instance launched from the old copy would otherwise keep running
  # (and `open` would just focus it) -- possibly holding the main container.
  pkill -f "^$APP2/Contents/MacOS/WeChat" && sleep 3
  rm -rf "$APP2"
  ditto "$APP" "$APP2" || { echo "ditto failed"; exit 1; }
  /usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $BUNDLE_ID2" "$APP2/Contents/Info.plist" || { echo "plist edit failed"; exit 1; }
  rm -rf "$SPARKLE2/Autoupdate" "$SPARKLE2/Updater.app" "$SPARKLE2/XPCServices"
  codesign --force --deep --sign - "$APP2" || { echo "codesign failed"; exit 1; }
  [ "$(bid "$APP2")" = "$BUNDLE_ID2" ] || { echo "bundle id verification failed"; exit 1; }
fi

defaults write "$BUNDLE_ID2" SUAutomaticallyUpdate -bool false

open -g -a "$APP2"
