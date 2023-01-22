//
//  导航后退按钮视图rx-ui数据绑定,初始化默认配置
//  Created by wangxiang4 on 2022/11/27.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import SwiftUI

class BarButtonItem: UIBarButtonItem {

    override init() {
        super.init()
        makeUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    
    // 渲染ui与数据绑定
    func makeUI() {
        // todo:
        
    }

}
