#!/bin/sh
#遇到错退出
set -v
CUR_DIR=$(cd "$(dirname "$0")"; pwd)

#当前时间
TRACK_CORE="pod \'GrowingAnalytics\/AutotrackerCore\'"
TRACK_CORE_CI="pod \'GrowingAnalytics\/AutotrackerCore', :path => \'.\/..\/growingio-sdk-ios-autotracker\'"

TRACK_CDP_CORE="pod \'GrowingAnalytics-cdp\/Autotracker\'"
TRACK_CDP_CORE_CI="pod \'GrowingAnalytics-cdp\/Autotracker', :path => \'.\/..\/growingio-sdk-ios-autotracker-cdp\'"

sed -i -e "s/${TRACK_CORE}/${TRACK_CORE_CI}/g" ${CUR_DIR}/../Podfile
sed -i -e "s/${TRACK_CDP_CORE}/${TRACK_CDP_CORE_CI}/g" ${CUR_DIR}/../Podfile