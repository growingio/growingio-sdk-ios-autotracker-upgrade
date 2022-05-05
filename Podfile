source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/aliyun/aliyun-specs.git'

# dont use framework
#use_frameworks!

install!'cocoapods',:deterministic_uuids=>false
platform :ios, '9.0'

workspace 'GrowingAnalytics-upgrade.xcworkspace'


target 'autotracker-upgrade-2to3-cdp' do
  project 'Example/Example'
#  pod 'GrowingAnalytics-upgrade/Tracker-upgrade-2to3-cdp', :path => './'
#  pod 'GrowingAnalytics-cdp/Tracker'
  pod 'GrowingAnalytics-cdp/Autotracker'
  pod 'GrowingAnalytics-upgrade/Autotracker-upgrade-2to3-cdp', :path => './'
  pod 'GrowingToolsKit'
end

# 下述内容: 用于打包空壳,工程在EmptyFramework
#target 'GrowingCDPCoreKit' do
#  project 'EmptyFramework/EmptyFramework.xcodeproj'
##  pod 'GrowingAnalytics-cdp/Tracker'
#  pod 'GrowingAnalytics-cdp/Autotracker'
#end
