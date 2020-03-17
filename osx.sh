# enable tap to click
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# enable three-finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -int 1
# reduce key repeat delay
defaults write NSGlobalDomain KeyRepeat -int 2
# reduce delay before key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# turn off long press latin characters
defaults write -g ApplePressAndHoldEnabled -bool false
# turn off antialiasing for terminal.app
defaults write com.apple.Terminal AppleFontSmoothing -int 0
# gureum config
defaults write org.youknowone.inputmethod.Gureum CIMRomanModeByEscapeKey YES
# set shortcut for gureum to cmd + space
defaults write org.youknowone.inputmethod.Gureum CIMInputModeExchangeKeyModifier 1048576
