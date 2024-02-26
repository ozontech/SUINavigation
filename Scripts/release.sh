#!/bin/bash

CHANGELOG=$(cat CHANGELOG.md)
VERSION_REGEX='## \[([.0-9]*)\]'
CURRENT_VERSION=""
if [[ $CHANGELOG =~ $VERSION_REGEX ]]; then
    CURRENT_VERSION=${BASH_REMATCH[1]}
fi

echo "Release version $CURRENT_VERSION detected"

APP_CONFIG_PATH="./build.config"
echo "CURRENT_VERSION=$CURRENT_VERSION" > "$APP_CONFIG_PATH"

cd Example/NavigationExample

xcrun simctl shutdown all
sh ../../Scripts/build.sh -c Debug -p NavigationExample -test 'platform=iOS Simulator,name=iPhone 15,OS=17.2'

xcrun simctl shutdown all
sh ../../Scripts/build.sh -c Debug -p NavigationExample -test 'platform=iOS Simulator,name=iPhone 15,OS=17.0.1'

xcrun simctl shutdown all
sh ../../Scripts/build.sh -c Debug -p NavigationExample -test 'platform=iOS Simulator,name=iPhone 14,OS=16.4'

xcrun simctl shutdown all
sh ../../Scripts/build.sh -c Debug -p NavigationExample -test 'platform=iOS Simulator,name=iPhone 14,OS=16.0'

xcrun simctl shutdown all
sh ../../Scripts/build.sh -c Debug -p NavigationExample -test 'platform=iOS Simulator,name=iPhone 13,OS=15.2'