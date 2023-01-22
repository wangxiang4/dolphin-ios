//
//  设置主题颜色自定义基础列视图模型
//  Created by wangxiang4 on 2022/11/29.
//  Copyright © 2022 entfrm All rights reserved.
//


import Foundation
import RxSwift
import RxCocoa

class ThemeCellViewModel: DefaultTableViewCellViewModel {

    let imageColor = BehaviorRelay<UIColor?>(value: nil)

    let theme: ColorTheme

    init(with theme: ColorTheme) {
        self.theme = theme
        super.init()
        title.accept(theme.title)
        imageColor.accept(theme.color)
    }
}
