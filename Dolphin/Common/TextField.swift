//
//  文本框视图rx-ui数据绑定,初始化默认配置
//  Created by wangxiang4 on 2022/11/27.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import SwiftUI

class TextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    override var placeholder: String? {
        didSet {
            themeService.switch(themeService.type)
        }
    }

    // 渲染ui与数据绑定
    func makeUI() {
        theme.textColor = themeService.attribute { $0.text }
        theme.tintColor = themeService.attribute { $0.secondary }
        theme.placeholderColor = themeService.attribute { $0.textGray }
        theme.borderColor = themeService.attribute { $0.text }
        theme.keyboardAppearance = themeService.attribute { $0.keyboardAppearance }

        layer.masksToBounds = true
        borderWidth = Configs.BaseComponentDimensions.borderWidth
        cornerRadius = Configs.BaseComponentDimensions.cornerRadius
        snp.makeConstraints { (make) in
            make.height.equalTo(Configs.BaseComponentDimensions.textFieldHeight)
        }
    }
}
