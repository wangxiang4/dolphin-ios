//
//  堆栈布局视图rx-ui数据绑定,初始化默认配置
//  Created by wangxiang4 on 2022/11/27.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import SwiftUI
class StackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    // 渲染ui与数据绑定
    func makeUI() {
        spacing = inset
        axis = .vertical
        setNeedsDisplay()
    }
}
