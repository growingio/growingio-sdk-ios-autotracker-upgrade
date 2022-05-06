#
# Be sure to run `pod lib lint GrowingIO.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GrowingAnalytics-upgrade'
  s.version          = '1.1.6'
  s.summary          = 'GrowingIO SDK udgrade, support for 2.x to 3.x'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://www.growingio.com/'
  s.license          = { :type => 'Apache2.0', :file => 'LICENSE' }
  s.author           = { 'GrowingIO' => 'support@growingio.com' }
  s.source           = { :git => 'https://github.com/growingio/growingio-sdk-ios-autotracker-upgrade.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.default_subspec = "Autotracker-upgrade-2to3-cdp"
  s.pod_target_xcconfig = {
    'HEADER_SEARCH_PATHS' => '"${PODS_TARGET_SRCROOT}" "${PODS_ROOT}/GrowingAnalytics" "${PODS_ROOT}/GrowingAnalytics-cdp"'
  }
  
  s.subspec 'Upgrade-base' do |base|
      base.source_files = 'Upgrade-base/**/*{.h,.m}'
      base.public_header_files = 'Upgrade-base/Public/*.h'
      base.dependency 'GrowingAnalytics/TrackerCore'
      base.vendored_frameworks = 'Upgrade-base/Frameworks/*.xcframework'
  end
  
  s.subspec 'Autotracker-upgrade-2to3-cdp' do |autotracker2to3cdp|
    autotracker2to3cdp.dependency 'GrowingAnalytics-upgrade/Upgrade-base'
    autotracker2to3cdp.dependency 'GrowingAnalytics-cdp/Autotracker'
    autotracker2to3cdp.vendored_frameworks = 'Autotracker-upgrade-2to3-cdp/Frameworks/*.xcframework'
  end
  
  s.subspec 'Tracker-upgrade-2to3-cdp' do |tracker2to3cdp|
    tracker2to3cdp.dependency 'GrowingAnalytics-upgrade/Upgrade-base'
    tracker2to3cdp.dependency 'GrowingAnalytics-cdp/Tracker'
    tracker2to3cdp.vendored_frameworks = 'Tracker-upgrade-2to3-cdp/Frameworks/*.xcframework'
  end
  
end
