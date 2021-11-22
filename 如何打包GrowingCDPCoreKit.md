# 如何打包 GrowingCDPCoreKit ?

1. 找到 growingio-sdk-ios-autotracker-upgrade/EmptyFramework 下的 `EmptyFramework.xcodeproj` 文件
2. 打开 GrowingAnalytics-upgrade.xcworkspace 将 `EmptyFramework.xcodeproj` 拖到 Workspace ，与 Example 同级

```
├── Example
├── EmptyFramework
├── Pods
```

3. 恢复 Podfile 下注释的部分

```
# 下述内容: 用于打包空壳,工程在EmptyFramework
target 'GrowingCDPCoreKit' do
  project 'EmptyFramework/EmptyFramework.xcodeproj'
  pod 'GrowingAnalytics-cdp/Tracker'
#  pod 'GrowingAnalytics-cdp/Autotracker'
end
```

4. 打包 **Tracker** 版本，在 GrowingCDPCoreKit/GrowingCoreKit.m 文件中，将 GROWING_AUTOTRACKER_CONFIG 值修改为 **0**
5. 然后进行 pod install，再进行编译名为 GrowingCDPCoreKit 的 Target，分别编译真机以及模拟器版本(Command + B)，编译模拟器版本需在 Build Phases -> Link Binary With Libraries 删除 libPods-GrowingCDPCoreKit.a，避免编译时报错
6. 使用 lipo -create 真机版本 模拟器版本 -output 生成最终版本，这里需要指定文件名，给出一个示例：

```
lipo -create /Users/sheng/Library/Developer/Xcode/DerivedData/GrowingAnalytics-upgrade-cxomsenmvudvngcanoifhendqyki/Build/Products/Release-iphoneos/GrowingCDPCoreKit.framework/GrowingCDPCoreKit /Users/sheng/Library/Developer/Xcode/DerivedData/GrowingAnalytics-upgrade-cxomsenmvudvngcanoifhendqyki/Build/Products/Release-iphonesimulator/GrowingCDPCoreKit.framework/GrowingCDPCoreKit -output /Users/sheng/Library/Developer/Xcode/DerivedData/GrowingAnalytics-upgrade-cxomsenmvudvngcanoifhendqyki/Build/Products/out/GrowingCDPCoreKit
```

7. 使用lipo -info 查看架构信息，符合要求则继续（armv7 i386 x86_64 arm64）

```
lipo -info /Users/sheng/Library/Developer/Xcode/DerivedData/GrowingAnalytics-upgrade-cxomsenmvudvngcanoifhendqyki/Build/Products/out/GrowingCDPCoreKit
Architectures in the fat file: /Users/sheng/Library/Developer/Xcode/DerivedData/GrowingAnalytics-upgrade-cxomsenmvudvngcanoifhendqyki/Build/Products/out/GrowingCDPCoreKit are: armv7 i386 x86_64 arm64
```

8. 然后将最终生成的 GrowingCDPCoreKit 版本，替换到 growingio-sdk-ios-autotracker-upgrade/Tracker-upgrade-2to3-cdp/Frameworks/GrowingCDPCoreKit.framework/GrowingCDPCoreKit
9. **Autotracker** 同理，修改 GROWING_AUTOTRACKER_CONFIG 值为 **1**，Podfile 修改为`pod 'GrowingAnalytics-cdp/Autotracker'`，进行同样操作，然后替换到 growingio-sdk-ios-autotracker-upgrade/Autotracker-upgrade-2to3-cdp/Frameworks/GrowingCDPCoreKit.framework/GrowingCDPCoreKit

 # 测试场景

1. CDP 2.0 用户集成 **Tracker-upgrade-2to3-cdp** 和 **GrowingAnalytics-cdp/Tracker**，升级至 3.0 ，验证触达 SDK 功能是否正常
2. CDP 3.0 新接入用户，集成**Autotracker-upgrade-2to3-cdp** 和 **GrowingAnalytics-cdp/Autotracker**，验证触达 SDK 功能是否正常