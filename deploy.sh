#!/bin/sh

# cd /Users/henrycatalinismith/666a.se/launch-agents
# git pull origin main
# git reset --hard origin/main

# Copy the launch agent to the LaunchDaemons directory
cp se.666a.backup.plist ~/Library/LaunchAgents/se.666a.backup.plist

# Reload se.666a.backup.plist so that the new version of the launch agent is loaded
launchctl bootout gui/501/se.666a.backup
launchctl bootstrap gui/501 /Users/henrycatalinismith/Library/LaunchAgents/se.666a.backup.plist
launchctl enable gui/501/se.666a.backup
