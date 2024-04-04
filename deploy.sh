#!/bin/sh

# Copy the launch agent to the LaunchDaemons directory
cp se.666a.backup.plist ~/Library/LaunchDaemons/se.666a.backup.plist

# Reload se.666a.backup.plist so that the new version of the launch agent is loaded
launchctl unload ~/Library/LaunchDaemons/se.666a.backup.plist
launchctl load ~/Library/LaunchDaemons/se.666a.backup.plist