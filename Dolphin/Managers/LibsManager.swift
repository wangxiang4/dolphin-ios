//
//  第三方依赖初始化管理
//  Created by 福尔摩翔 on 2022/12/5.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//

import RxSwift
import RxCocoa
import SnapKit
import IQKeyboardManagerSwift
import CocoaLumberjack
import Kingfisher
#if DEBUG
import FLEX
#endif
import NSObject_Rx
import RxViewController
import RxOptional
import RxGesture
import SwifterSwift
import SwiftDate
import Hero
import KafkaRefresh
import DropDown
import Toast_Swift
typealias DropDownView = DropDown

// 全局黑暗与明亮主题切换
let nightModeEnabled: BehaviorRelay<Bool> = BehaviorRelay(value: ThemeType.currentTheme().isDark)

class LibsManager: NSObject {

    func setupLibs(with window: UIWindow? = nil) {
        let libsManager: LibsManager = DIContainer.shared.resolve()
        libsManager.setupCocoaLumberjack()
        libsManager.setupTheme()
        libsManager.setupKafkaRefresh()
        libsManager.setupFLEX()
        libsManager.setupKeyboardManager()
        libsManager.setupDropDown()
        libsManager.setupToast()
    }

    // 设置主题
    func setupTheme() {
        UIApplication.shared.theme.statusBarStyle = themeService.attribute { $0.statusBarStyle }
        nightModeEnabled.subscribe(onNext: { (isEnabled) in
            var theme = ThemeType.currentTheme()
            if theme.isDark != isEnabled {
                theme = theme.toggled()
            }
            themeService.switch(theme)
        }).disposed(by: rx.disposeBag)
    }

    // 设置下拉列表
    func setupDropDown() {
        themeService.typeStream.subscribe(onNext: { (themeType) in
            let theme = themeType.associatedObject
            DropDown.appearance().backgroundColor = theme.primary
            DropDown.appearance().selectionBackgroundColor = theme.primaryDark
            DropDown.appearance().textColor = theme.text
            DropDown.appearance().selectedTextColor = theme.text
            DropDown.appearance().separatorColor = theme.separator
        }).disposed(by: rx.disposeBag)
    }

    // 设置吐司
    func setupToast() {
        ToastManager.shared.isTapToDismissEnabled = true
        ToastManager.shared.position = .bottom
        var style = ToastStyle()
        style.backgroundColor = UIColor.Material.red
        style.messageColor = UIColor.Material.white
        style.imageSize = CGSize(width: 20, height: 20)
        ToastManager.shared.style = style
    }

    // 设置下拉刷新
    func setupKafkaRefresh() {
        if let defaults = KafkaRefreshDefaults.standard() {
            defaults.headDefaultStyle = .replicatorAllen
            defaults.footDefaultStyle = .replicatorDot
            defaults.theme.themeColor = themeService.attribute { $0.secondary }
        }
    }

    // 设置键盘遮挡输入
    func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true
    }

    // 设置图片处理
    func setupKingfisher() {
        // 为默认缓存设置最大磁盘缓存大小。默认值为0，这意味着没有限制
        ImageCache.default.diskStorage.config.sizeLimit = UInt(500 * 1024 * 1024) // 500 MB

        // 设置存储在磁盘中的缓存的最长持续时间。默认值为1周
        ImageCache.default.diskStorage.config.expiration = .days(7) // 1 week

        // 为默认图像下载器设置超时持续时间。默认值为15秒。
        ImageDownloader.default.downloadTimeout = 15.0 // 15 sec
    }

    // 设置日志
    func setupCocoaLumberjack() {
        DDLog.add(DDOSLogger.sharedInstance)
        // 文件记录器
        let fileLogger: DDFileLogger = DDFileLogger()
        // 24 小时
        fileLogger.rollingFrequency = TimeInterval(60*60*24)
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }

    // 设置程序内调试工具
    func setupFLEX() {
        #if DEBUG
        FLEXManager.shared.isNetworkDebuggingEnabled = true
        #endif
    }
    
}

extension LibsManager {

    func showFlex() {
        #if DEBUG
        FLEXManager.shared.showExplorer()
        #endif
    }

    func removeKingfisherCache() -> Observable<Void> {
        return ImageCache.default.rx.clearCache()
    }

    func kingfisherCacheSize() -> Observable<Int> {
        return ImageCache.default.rx.retrieveCacheSize()
    }
    
}
