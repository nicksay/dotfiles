#!/bin/bash

set -e  # Stop on error.
cd "$(dirname "$0")" # Run from the the script directory.


echo
echo "Setting defaults..."


# Ask for sudo access before starting.
sudo -v


# Kill normal apps before setting defaults so values aren't overwritten.
killall "App Store" "System Preferences" &> /dev/null || true


# Global

# Using charger (-c): Prevent computer from sleeping automatically
sudo pmset -c sleep 0
# Using charger (-c): Turn display off after 10 minutes
sudo pmset -c displaysleep 10
# Set highlight color to orange
defaults write NSGlobalDomain AppleHighlightColor -string "1.000000 0.874510 0.701961"
# Enable full keyboard access for all control (e.g. enable Tab in dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
# Disable the "double-space to insert period"
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
# Make the mouse tracking speed faster
defaults write NSGlobalDomain com.apple.mouse.scaling -float 1.0
# Enable right-click when using a Magic Mouse
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string TwoButton
# Disable three-finger-tap when using the trackpad
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 0
# Disable force-touch and haptic feedback when using the trackpad
defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad ActuateDetents  -bool false
defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad ForceSuppressed  -bool true
# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
# Disable quarantine warnings about unidentified developers
defaults write com.apple.LaunchServices LSQuarantine -bool false
# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true
# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true


# Finder

# Set Home as the default location for new Finder windows
defaults write com.apple.finder NewWindowTarget -string "PfHm"
# Show status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true
# Show path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true
# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
# Use column view in all Finder windows by default
# Four-letter codes: Flwv (Cover Flow), Nlsv (List), clmv (Column), icnv (Icon)
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
# Show the ~/Library folder
chflags nohidden ~/Library


# Dock

# Set the Dock position to left
defaults write com.apple.dock orientation -string "left"
# Set the icon size of Dock items to 48 pixels
defaults write com.apple.dock tilesize -int 48
# Match the default Dock icon size for magnification
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 48
# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true
# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true
# Remove the delay when showing the Dock and make the animation faster
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.2
# Make the Launchpad animations faster
defaults write com.apple.dock springboard-show-duration -float 0.1
defaults write com.apple.dock springboard-hide-duration -float 0.1
defaults write com.apple.dock springboard-page-duration -float 0.3
# Clear persistent applications
defaults write com.apple.dock persistent-apps remove
# Don't show recent applications
defaults write com.apple.dock show-recents -bool false


# Spotlight
defaults write com.apple.Spotlight orderedItems '(
    { enabled = 1; name = APPLICATIONS; },
    { enabled = 1; name = "MENU_CONVERSION"; },
    { enabled = 1; name = "MENU_EXPRESSION"; },
    { enabled = 1; name = "MENU_DEFINITION"; },
    { enabled = 1; name = "SYSTEM_PREFS"; },
    { enabled = 0; name = "MENU_SPOTLIGHT_SUGGESTIONS"; },
    { enabled = 0; name = DOCUMENTS; },
    { enabled = 0; name = DIRECTORIES; },
    { enabled = 0; name = PRESENTATIONS; },
    { enabled = 0; name = SPREADSHEETS; },
    { enabled = 0; name = PDF; },
    { enabled = 0; name = MESSAGES; },
    { enabled = 0; name = CONTACT; },
    { enabled = 0; name = "EVENT_TODO"; },
    { enabled = 0; name = IMAGES; },
    { enabled = 0; name = BOOKMARKS; },
    { enabled = 0; name = MUSIC; },
    { enabled = 0; name = MOVIES; },
    { enabled = 0; name = FONTS; },
    { enabled = 0; name = "MENU_OTHER"; },
    { enabled = 0; name = SOURCE; }
)'
defaults write com.apple.Spotlight showedFTE -bool true
defaults write com.apple.Spotlight showedLearnMore -bool true


# App Store / Software Update

# Enable the automatic update check
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
# Check for software updates daily, not just once per week
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ScheduleFrequency -int 1
# Install System data files & security updates
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
# Auto-update apps
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true


# Kill persistent apps after setting defaults so changes take effect.
killall ControlStrip Dock Finder &> /dev/null || true


echo "Defaults set."
