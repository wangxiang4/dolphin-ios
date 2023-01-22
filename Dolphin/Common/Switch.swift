//
//  开关视图rx-ui数据绑定,初始化默认配置
//  Created by 福尔摩翔 on 2022/11/27.
//  Copyright © 2022 entfrm All rights reserved.
//

import UIKit

class Switch: UISwitch {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    // 渲染ui与数据绑定
    func makeUI() {
        self.theme.tintColor = themeService.attribute { $0.secondary }
        self.theme.onTintColor = themeService.attribute { $0.secondary }
    }
}
