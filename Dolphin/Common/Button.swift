//
//  按钮视图rx-ui数据绑定,初始化默认配置
//  Created by wangxiang4 on 2022/11/27.
//  Copyright © 2022 entfrm All rights reserved.
//

import SwiftUI

public class Button: UIButton {

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
        
        // rx主题绑定
        theme.backgroundImage(from: themeService.attribute { $0.secondary }, for: .normal)
        theme.backgroundImage(from: themeService.attribute { $0.secondary.withAlphaComponent(0.9) }, for: .selected)
        theme.backgroundImage(from: themeService.attribute { $0.secondary.withAlphaComponent(0.6) }, for: .disabled)

        // 初始化默认配置
        layer.masksToBounds = true
        titleLabel?.lineBreakMode = .byWordWrapping
        cornerRadius = Configs.BaseComponentDimensions.cornerRadius
        snp.makeConstraints { (make) in
            make.height.equalTo(Configs.BaseComponentDimensions.buttonHeight)
        }
        setNeedsDisplay()
    }

}
