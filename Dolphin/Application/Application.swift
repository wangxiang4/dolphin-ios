//
//  初始启动界面
//  Created by wangxiang4 on 2022/11/27.
//  Copyright © 2022 entfrm All rights reserved.
//

import SwiftUI

final class Application: NSObject {

    // 首个ui窗口对象:提供绘画支持给屏幕
    var window: UIWindow?

    // 初始化首次场景
    func presentInitialScreen(in window: UIWindow?) {
        guard let window = window else { return }
        self.window = window
        
        if !StrUtil.isTrimEmpty((DIContainer.shared.resolve() as AuthManager).tokenEnhancer?.access_token) {
            // 呈现首页标签栏场景
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                let homeTabBarVC: HomeTabBarViewController = HomeTabBarViewController(viewModel: HomeTabBarViewModel())
                let initialSplitVC: InitialSplitViewController = InitialSplitViewController(viewModel: nil)
                let navigationC = NavigationController(rootViewController: initialSplitVC)
                let splitVC = SplitViewController()
                splitVC.viewControllers = [homeTabBarVC, navigationC]
                UIView.transition(with: window, duration: 3.5, options: .transitionCurlUp, animations: {
                    window.rootViewController = splitVC
                }, completion: nil)
            }
            return
        }
        
        // 呈现登录场景
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            UIView.transition(with: window, duration: 3.5, options: .transitionCurlDown, animations: {
                window.rootViewController = LoginViewController(viewModel: LoginViewModel())
            }, completion: nil)
        }
    }
}
