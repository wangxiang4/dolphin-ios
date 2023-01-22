//
//  右手动画部分
//  Created by wangxiang4 on 2022/12/5.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import SwiftUI
final class RightArm: UIImageView, CritterAnimatable {

    var isShy = false

    convenience init() {
        self.init(image: UIImage.Critter.rightArm)
        layer.zPosition = 30
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let superview = superview else { return }

        let originY = superview.bounds.maxY
        frame = CGRect(x: 92.6, y: originY, width: 42.3, height: 93.2)
    }

    func applyShyState() {
        if isShy {
            layer.transform = CATransform3D
                .identity
                .translate(.y, by: -82.6)
        } else {
            layer.transform = .identity
        }
    }

    func applyPeekState() {
        layer.transform = CATransform3D
            .identity
            .translate(.y, by: -70.6)
    }

    func applyUnPeekState() {
        if isShy {
            applyShyState()
        } else {
            applyInactiveState()
        }
    }
}
