//
//  平板分割视图控制器数据绑定,初始化默认配置
//  Created by wangxiang4 on 2022/11/27.
//  Copyright © 2022 entfrm All rights reserved.
//

import SwiftUI

class SplitViewController: UISplitViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return globalStatusBarStyle.value
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 初始化数据绑定
        delegate = self
        preferredDisplayMode = .allVisible
        globalStatusBarStyle.mapToVoid().subscribe(onNext: { [weak self] () in
            self?.setNeedsStatusBarAppearanceUpdate()
        }).disposed(by: rx.disposeBag)
    }
}

extension SplitViewController: UISplitViewControllerDelegate {

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
