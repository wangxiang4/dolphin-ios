//
//  鼻子动画部分
//  Created by wangxiang4 on 2022/12/5.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import SwiftUI
final class Nose: UIImageView, CritterAnimatable {

    private let p1 = CGPoint(x: 22.2, y: 2.2)
    private let p2 = CGPoint(x: 12.6, y: 5.2)

    convenience init() {
        self.init(image: UIImage.Critter.nose)
        frame = CGRect(x: p1.x, y: p1.y, width: 13, height: 9.6)
    }

    // MARK: - CritterAnimatable
    func applyActiveStartState() {
        layer.transform = CATransform3D
            .identity
            .translate(.x, by: p2.x - p1.x)
            .translate(.y, by: p2.y - p1.y)
    }
    
    func applyActiveEndState() {
        layer.transform = CATransform3D
            .identity
            .translate(.x, by: -(p2.x - p1.x))
            .translate(.y, by: p2.y - p1.y)
    }
}
