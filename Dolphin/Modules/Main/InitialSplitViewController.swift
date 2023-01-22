//
//  默认平板分割视图控制器右视图场景
//  Created by 福尔摩翔 on 2022/11/27.
//  Copyright © 2022 entfrm All rights reserved.
//

import SwiftUI
class InitialSplitViewController: TableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func makeUI() {
        super.makeUI()
        // 移除头部跟底部刷新,引导页展示
        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil
    }
}
