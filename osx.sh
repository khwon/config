#!/bin/bash
# enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# enable three-finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
# reduce key repeat delay
defaults write NSGlobalDomain KeyRepeat -int 2
# reduce delay before key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# turn off long press latin characters
defaults write -g ApplePressAndHoldEnabled -bool false
# gureum config
defaults write org.youknowone.inputmethod.Gureum CIMRomanModeByEscapeKey YES
# set shortcut for gureum to cmd + space
defaults write org.youknowone.inputmethod.Gureum CIMInputModeExchangeKeyModifier 1048576
