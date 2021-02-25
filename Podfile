source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/aliyun/aliyun-specs.git'

use_frameworks!

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


target 'GrowingCDPCoreKit' do
  project 'EmptyFramework/EmptyFramework'
  pod 'GrowingAnalytics-cdp/Autotracker', '~> 3.0.2'
end


