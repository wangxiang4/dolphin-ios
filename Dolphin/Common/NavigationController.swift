//
//  导航栏控制器数据绑定,初始化默认配置
//  Created by wangxiang4 on 2022/11/27.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return globalStatusBarStyle.value
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hero.isEnabled = true
        // 初始化数据绑定
        hero.modalAnimationType = .autoReverse(presenting: .fade)
        hero.navigationAnimationType = .autoReverse(presenting: .slide(direction: .left))

        navigationBar.backIndicatorImage = R.image.icon_navigation_back()
        navigationBar.backIndicatorTransitionMaskImage = R.image.icon_navigation_back()

        navigationBar.theme.tintColor = themeService.attribute { $0.secondary }
        navigationBar.theme.barTintColor = themeService.attribute { $0.primaryDark }
        navigationBar.theme.titleTextAttributes = themeService.attribute { [NSAttributedString.Key.foregroundColor: $0.text] }
    }
}
