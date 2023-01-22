//
//  初始化应用程序
//  Created by wangxiang4 on 2022/11/27.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import SwiftUI
import Toast_Swift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // 首个ui窗口对象:提供绘画支持给屏幕
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        // 初始化加载第三方库
        let libsManager: LibsManager = DIContainer.shared.resolve()
        libsManager.setupLibs(with: window)

        // 注册用户通知
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        // 横幅，声音，标记
        center.requestAuthorization(options: [.alert, .sound, .badge]) {(accepted, error) in
            if error != nil {
                print("推送消息成功")
            }
        }
        application.registerForRemoteNotifications()
        
        // 用于断网后连接到互联网订阅提醒
        connectedToInternet().skip(1).subscribe(onNext: { [weak self] (connected) in
            var style = ToastManager.shared.style
            style.backgroundColor = connected ? UIColor.Material.green: UIColor.Material.red
            let message = connected ? R.string.localizable.toastConnectionBackMessage.key.localized(): R.string.localizable.toastConnectionLostMessage.key.localized()
            let image = connected ? R.image.icon_toast_success(): R.image.icon_toast_warning()
            if let view = self?.window?.rootViewController?.view {
                view.makeToast(message, position: .bottom, image: image, style: style)
            }
        }).disposed(by: rx.disposeBag)

        // 显示初始启动界面
        let application:Application = DIContainer.shared.resolve()
        application.presentInitialScreen(in: window!)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

// 扩展用户通知中心委托
// https://developer.apple.com/documentation/usernotifications/handling_notifications_and_notification-related_actions
@available(iOS 14.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 弹出通知
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        completionHandler(UNNotificationPresentationOptions(rawValue: UNNotificationPresentationOptions.RawValue(
            UInt8(UNNotificationPresentationOptions.badge.rawValue) |
            UInt8(UNNotificationPresentationOptions.alert.rawValue) |
            UInt8(UNNotificationPresentationOptions.sound.rawValue) |
            UInt8(UNNotificationPresentationOptions.list.rawValue)
        )))
    }
    
    // 点击通知
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 可以在这里做跳转处理
        completionHandler()
    }
    
}
