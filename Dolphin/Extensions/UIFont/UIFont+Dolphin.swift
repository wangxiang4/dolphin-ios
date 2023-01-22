//
//  扩展UI字体组件
//  Created by 福尔摩翔 on 2022/12/5.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//


import SwiftUI
import Foundation

extension UIFont {

    static func navigationTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 17.0)
    }

    static func titleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 17.0)
    }

    static func descriptionFont() -> UIFont {
        return UIFont.systemFont(ofSize: 14.0)
    }
}

extension UIFont {

    // 获取所以系统字体名称
    static func allSystemFontsNames() -> [String] {
        var fontsNames = [String]()
        let fontFamilies = UIFont.familyNames
        for fontFamily in fontFamilies {
            let fontsForFamily = UIFont.fontNames(forFamilyName: fontFamily)
            for fontName in fontsForFamily {
                fontsNames.append(fontName)
            }
        }
        return fontsNames
    }
}
