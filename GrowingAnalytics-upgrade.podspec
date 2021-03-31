#
# Be sure to run `pod lib lint GrowingIO.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GrowingAnalytics-upgrade'
  s.version          = '1.1.0-beta'
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
  'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' 
  }
  s.user_target_xcconfig = { 
  'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
  
  s.subspec 'Upgrade-base' do |base|
      base.source_files = 'Upgrade-base/**/*{.h,.m}'
      base.dependency 'GrowingAnalytics-cdp/Autotracker'
      base.dependency 'GrowingAnalytics/AutotrackerCore'
  end
  
  s.subspec 'Autotracker-upgrade-2to3-cdp' do |autotracker2to3cdp|
      autotracker2to3cdp.source_files = 'Autotracker-upgrade-2to3-cdp/**/*{.h}'
      autotracker2to3cdp.dependency 'GrowingAnalytics-upgrade/Upgrade-base'
      autotracker2to3cdp.vendored_frameworks = 'Autotracker-upgrade-2to3-cdp/Frameworks/*.framework'
  end
  
end
