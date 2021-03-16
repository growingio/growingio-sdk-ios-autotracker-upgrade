source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/aliyun/aliyun-specs.git'

# dont use framework
#use_frameworks!

install!'cocoapods',:deterministic_uuids=>false
platform :ios, '9.0'

workspace 'GrowingAnalytics-upgrade.xcworkspace'


target 'autotracker-upgrade-2to3-cdp' do
  project 'Example/Example'
  pod 'GrowingAnalytics-upgrade/Autotracker-upgrade-2to3-cdp', :path => './'
  pod 'GrowingAnalytics-cdp/Autotracker', '~> 3.0.2'
  pod 'SDCycleScrollView', '~> 1.75'
  pod 'MJRefresh', '~> 3.4.3'
  pod 'SDWebImage', '~> 5.8.4'
  pod 'MBProgressHUD', '~> 1.2.0'
end


#target 'autotracker-upgrade-2to3' do
#  project 'Example/Example'
#  pod 'GrowingAnalytics-upgrade/Autotracker-upgrade-2to3', :path => './'
#  pod 'SDCycleScrollView', '~> 1.75'
#  pod 'MJRefresh', '~> 3.4.3'
#  pod 'SDWebImage', '~> 5.8.4'
#  pod 'MBProgressHUD', '~> 1.2.0'
#end


# 用于打包空壳,工程在EmptyFramework

target 'GrowingCDPCoreKit' do
  project 'EmptyFramework/EmptyFramework.xcodeproj'
  pod 'GrowingAnalytics-cdp/Autotracker', '~> 3.0.2'
  pod 'GrowingAnalytics-upgrade/Upgrade-base', :path => './'
end
#
#
#target 'GrowingCoreKit' do
#  project 'EmptyFramework/EmptyFramework.xcodeproj'
#  pod 'GrowingAnalytics/Autotracker', '~> 3.0.2'
#  pod 'GrowingAnalytics-upgrade/Upgrade-base', :path => './'
#end

