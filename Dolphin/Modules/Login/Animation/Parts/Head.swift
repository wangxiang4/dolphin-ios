//
//  头动画部分
//  Created by wangxiang4 on 2022/12/5.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import SwiftUI
final class Head: UIImageView, CritterAnimatable {

    convenience init() {
        self.init(image: UIImage.Critter.head)
        frame = CGRect(x: 27.3, y: 52.1, width: 105.5, height: 90.9)
    }

    // MARK: - CritterAnimatable
    func applyActiveStartState() {
        layer.transform = CATransform3D
            .identity
            .rotate(.x, by: -20.0.degrees)
            .rotate(.y, by: -18.0.degrees)
            .perspective()
    }

    func applyActiveEndState() {
        layer.transform = CATransform3D
            .identity
            .rotate(.x, by: -20.0.degrees)
            .rotate(.y, by: 18.0.degrees)
            .perspective()
    }
}
