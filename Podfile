source 'https://github.com/growingio/giospec.git'
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/aliyun/aliyun-specs.git'

use_frameworks!

install!'cocoapods',:deterministic_uuids=>false
platform :ios, '9.0'

workspace 'GrowingAnalytics-upgrade.xcworkspace'

target 'autotracker-upgrade-2to3-cdp' do
  project 'Example/Example'
  pod 'GrowingAnalytics-upgrade/Autotracker-upgrade-2to3-cdp', :path => './'
  pod 'GrowingAnalytics-cdp/Autotracker'
  pod 'GrowingAnalytics/AutotrackerCore'
  pod 'SDCycleScrollView', '~> 1.75'
  pod 'MJRefresh'
  pod 'MBProgressHUD'
end


target 'GrowingCDPCoreKit' do
  project 'EmptyFramework/EmptyFramework'
  pod 'GrowingAnalytics-upgrade/Autotracker-upgrade-2to3-cdp', :path => './'
  pod 'GrowingAnalytics-cdp/Autotracker'
  pod 'GrowingAnalytics/AutotrackerCore'

end


