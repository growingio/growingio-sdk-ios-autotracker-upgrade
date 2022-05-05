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
6. 使用 xcodebuild -create-xcframework <真机 framework\> <模拟器 framework\> -output 生成 xcframework，这里需要指定文件名，给出一个示例：

```
xcodebuild -create-xcframework \
-framework <iPhone OS framework 路径> \
-framework <iPhone simulator framework 路径> \
-output GrowingCDPCoreKit.xcframework
```

7. 使用 Finder 或 tree 指令查看架构信息，符合要求则继续（ios-**arm64_armv7** 以及 ios-**arm64_i386_x86_64**-simulator），**另外，可删除 ios-arm64_i386_x86_64-simulator/GrowingCDPCoreKit.framework 目录下生成的无用签名相关文件**

```
GrowingCDPCoreKit.xcframework/
├── Info.plist
├── ios-arm64_armv7
│   └── GrowingCDPCoreKit.framework
│       ├── GrowingCDPCoreKit
│       ├── Headers
│       │   └── GrowingCoreKit.h
│       └── Info.plist
└── ios-arm64_i386_x86_64-simulator
    └── GrowingCDPCoreKit.framework
        ├── GrowingCDPCoreKit
        ├── Headers
        │   └── GrowingCoreKit.h
        └── Info.plist
```

8. 然后将最终生成的 GrowingCDPCoreKit.xcframework，替换到 growingio-sdk-ios-autotracker-upgrade/Tracker-upgrade-2to3-cdp/Frameworks/GrowingCDPCoreKit.xcframework
9. **Autotracker** 同理，修改 GROWING_AUTOTRACKER_CONFIG 值为 **1**，Podfile 修改为`pod 'GrowingAnalytics-cdp/Autotracker'`，进行同样操作，然后替换到 growingio-sdk-ios-autotracker-upgrade/Autotracker-upgrade-2to3-cdp/Frameworks/GrowingCDPCoreKit.xcframework

 # 测试场景

1. CDP 2.0 用户集成 **Tracker-upgrade-2to3-cdp** 和 **GrowingAnalytics-cdp/Tracker**，升级至 3.0 ，验证触达 SDK 功能是否正常
2. CDP 3.0 新接入用户，集成**Autotracker-upgrade-2to3-cdp** 和 **GrowingAnalytics-cdp/Autotracker**，验证触达 SDK 功能是否正常