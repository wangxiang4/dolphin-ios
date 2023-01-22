//
//  扩展UI颜色组件
//  Created by 福尔摩翔 on 2022/12/5.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//

import SwiftUI

extension UIColor {

    static func primary() -> UIColor {
        return themeService.type.associatedObject.primary
    }

    static func primaryDark() -> UIColor {
        return themeService.type.associatedObject.primaryDark
    }

    static func secondary() -> UIColor {
        return themeService.type.associatedObject.secondary
    }

    static func secondaryDark() -> UIColor {
        return themeService.type.associatedObject.secondaryDark
    }

    static func separator() -> UIColor {
        return themeService.type.associatedObject.separator
    }

    static func text() -> UIColor {
        return themeService.type.associatedObject.text
    }
}
