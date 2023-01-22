# 取消注释下一行为您的项目定义全局平台
platform :ios, '14.0'

# 使用框架动态加载第三方依赖
use_frameworks!
# 抑制CocoaPods引入的第三方代码库产生的警告
inhibit_all_warnings!

target 'Dolphin' do
  # 网络
  # https://github.com/Moya/Moya
  pod 'Moya/RxSwift', '~> 15.0'

  # Rx扩展
  # https://github.com/RxSwiftCommunity/RxDataSources
  pod 'RxDataSources', '~> 5.0'
  # https://github.com/RxSwiftCommunity/RxSwiftExt
  pod 'RxSwiftExt', '~> 6.0'
  # https://github.com/RxSwiftCommunity/NSObject-Rx
  pod 'NSObject+Rx', '~> 5.0'
  # https://github.com/devxoul/RxViewController
  pod 'RxViewController', '~> 2.0'
  # https://github.com/RxSwiftCommunity/RxGesture
  pod 'RxGesture', '~> 4.0'
  # https://github.com/RxSwiftCommunity/RxOptional
  pod 'RxOptional', '~> 5.0'
  # https://github.com/RxSwiftCommunity/RxTheme
  pod 'RxTheme', '~> 6.0'
  # https://github.com/Swinject/Swinject
  pod 'Swinject', '~>2.0'
  
  # JSON映射
  # https://github.com/ivanbruel/Moya-ObjectMapper
  pod 'Moya-ObjectMapper/RxSwift',
    :git => 'https://github.com/p-rob/Moya-ObjectMapper.git',
    :branch => 'master'

  # 图片处理
  # https://github.com/onevcat/Kingfisher
  pod 'Kingfisher', '~> 7.0'

  # 日期处理工具
  # https://github.com/MatthewYork/DateTools
  pod 'DateToolsSwift', '~> 5.0'
  # https://github.com/malcommac/SwiftDate
  pod 'SwiftDate', '~> 6.0'

  # swift编译工具
  # https://github.com/mac-cain13/R.swift
  pod 'R.swift', '~> 6.0'
  # https://github.com/realm/SwiftLint
  pod 'SwiftLint', '0.47.1'

  # 苹果钥匙串处理
  # https://github.com/kishikawakatsumi/KeychainAccess
  pod 'KeychainAccess', '~> 4.0'

  # UI视图扩展
  # https://github.com/SVProgressHUD/SVProgressHUD
  pod 'SVProgressHUD', '~> 2.0'
  # https://github.com/dzenbot/DZNEmptyDataSet
  pod 'DZNEmptyDataSet', '~> 1.0'
  # https://github.com/lkzhao/Hero
  pod 'Hero', '~> 1.6'
  # https://github.com/marmelroy/Localize-Swift
  pod 'Localize-Swift', '~> 3.0'
  # https://github.com/Ramotion/animated-tab-bar
  pod 'RAMAnimatedTabBarController', '~> 5.0'
  # https://github.com/OpenFeyn/KafkaRefresh
  pod 'KafkaRefresh', '~> 1.0'
  # https://github.com/SvenTiigi/WhatsNewKit
  pod 'WhatsNewKit', '~> 1.0'
  # https://github.com/AssistoLab/DropDown
  pod 'DropDown', '~> 2.0'
  # https://github.com/scalessec/Toast-Swift
  pod 'Toast-Swift', '~> 5.0'
  # https://github.com/HeshamMegid/HMSegmentedControl
  pod 'HMSegmentedControl', '~> 1.0'
  # https://github.com/zvonicek/ImageSlideshow
  pod 'ImageSlideshow/Kingfisher',
    :git => 'https://github.com/khoren93/ImageSlideshow.git',
    :branch => 'master'

  
  # 防止键盘向上滑动并覆盖输入视图
  # https://github.com/hackiftekhar/IQKeyboardManager
  pod 'IQKeyboardManagerSwift', '~> 6.0'

  # 视图自动布局处理
  # https://github.com/SnapKit/SnapKit
  pod 'SnapKit', '~> 5.0'

  # 测试工具
  # https://github.com/Flipboard/FLEX
  pod 'FLEX', '~> 5.0', :configurations => ['Debug']
  
  # swift扩展
  # https://github.com/SwifterSwift/SwifterSwift
  pod 'SwifterSwift', '~> 5.0'
  
  # 字符串美化工具
  # https://github.com/Rightpoint/BonMot
  pod 'BonMot', '~> 6.0'

  # 打印日志
  # https://github.com/CocoaLumberjack/CocoaLumberjack
  pod 'CocoaLumberjack/Swift', '~> 3.0'
  
  # 加密工具
  # https://github.com/krzyzanowskim/CryptoSwift
  pod 'CryptoSwift', '~> 1.6.0'
  
  # https://www.jianshu.com/p/dfaf0954b76d
  target 'DolphinTests' do
      inherit! :search_paths
      # todo: pods for testing dependence
      # 测试框架
      # https://github.com/Quick/Quick
      pod 'Quick', '~> 5.0'
      # 断言匹配框架
      # https://github.com/Quick/Nimble
      pod 'Nimble', '~> 9.0'
  end
end

target 'DolphinUITests' do
    inherit! :search_paths
    # todo: pods for uitesting dependence
end


# 安装后处理勾子
post_install do |installer|
  
    # Cocoapods包管理优化,缓存创建framework库的链接,避免重写安装项目在创建一次framework库的链接
    Dir.glob(installer.sandbox.target_support_files_root + "Pods-*/*.sh").each do |script|
        flag_name = File.basename(script, ".sh") + "-Installation-Flag"
        folder = "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
        file = File.join(folder, flag_name)
        content = File.read(script)
        content.gsub!(/set -e/, "set -e\nKG_FILE=\"#{file}\"\nif [ -f \"$KG_FILE\" ]; then exit 0; fi\nmkdir -p \"#{folder}\"\ntouch \"$KG_FILE\"")
        File.write(script, content)
    end
    
    # 跟踪rxswift函数统计
    # https://juejin.cn/post/6844903925905096717
    installer.pods_project.targets.each do |target|
      if target.name == 'RxSwift'
        target.build_configurations.each do |config|
          if config.name == 'Debug'
            config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
          end
        end
      end
    end
end
