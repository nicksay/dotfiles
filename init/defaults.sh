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

# Set highlight color to orange
defaults write NSGlobalDomain AppleHighlightColor -string "1.000000 0.874510 0.701961"
# Enable full keyboard access for all control (e.g. enable Tab in dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
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
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
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
# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true
# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true
# Remove the delay when showing the Dock and make the animation faster
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.2


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
killall Dock Finder &> /dev/null || true


echo "Defaults set."
