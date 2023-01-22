//
//  动画角度
//  Created by wangxiang4 on 2022/12/5.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import SwiftUI
struct Degree {

    let value: Double

    var radians: CGFloat {
        return CGFloat(value * Double.pi / 180.0)
    }
}

// MARK: - 自定义减去角度度运算符
prefix func -(degree: Degree) -> Degree {
    return Degree(value: -1 * degree.value)
}

// MARK: - Double
extension Double {
    var degrees: Degree {
        return Degree(value: self)
    }
}
