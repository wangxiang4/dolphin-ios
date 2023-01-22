//
//  左眼动画部分
//  Created by 福尔摩翔 on 2022/12/5.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//

import SwiftUI

final class LeftEye: UIImageView, CritterAnimatable {

    private let p1 = CGPoint(x: 21.8, y: 28.8)
    private let p2 = CGPoint(x: 9.7, y: 41.1)

    convenience init() {
        self.init(image: UIImage.Critter.eye)
        frame = CGRect(x: p1.x, y: p1.y, width: 11.7, height: 11.7)
    }

    // MARK: - CritterAnimatable
    func applyActiveStartState() {
        let eyeScale: CGFloat = 1.12
        let eyeTransform = CATransform3D
            .identity
            .scale(.x, by: eyeScale)
            .scale(.y, by: eyeScale)
            .scale(.z, by: 1.01) // 🎩✨ Magic to prevent 'jumping'

        layer.transform = eyeTransform
            .translate(.x, by: p2.x - p1.x)
            .translate(.y, by: p2.y - p1.y)
    }

    func applyActiveEndState() {
        let eyeScale: CGFloat = 1.12
        let eyeTransform = CATransform3D
            .identity
            .scale(.x, by: eyeScale)
            .scale(.y, by: eyeScale)
            .scale(.z, by: 1.01) // 🎩✨ Magic to prevent 'jumping'

        layer.transform = eyeTransform
            .translate(.x, by: -(p2.x - p1.x))
            .translate(.y, by: p2.y - p1.y)
    }
}
