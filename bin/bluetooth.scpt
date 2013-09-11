#!/usr/bin/osascript
tell application "System Preferences"
  set current pane to pane id "com.apple.preferences.bluetooth"
  tell application "System Events"
    tell process "System Preferences"
      click checkbox "On" of window "Bluetooth"
    end tell
  end tell
  quit
end tell
