//
//  工具栏视图rx-ui数据绑定,初始化默认配置
//  Created by wangxiang4 on 2022/11/27.
//  Copyright © 2022 entfrm All rights reserved.
//

import SwiftUI
class Toolbar: UIToolbar {

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
        isTranslucent = false
        theme.barStyle = themeService.attribute { $0.barStyle }
        theme.barTintColor = themeService.attribute { $0.primaryDark }
        theme.tintColor = themeService.attribute { $0.secondary }
        snp.makeConstraints { (make) in
            make.height.equalTo(Configs.BaseComponentDimensions.tableRowHeight)
        }
    }
}
