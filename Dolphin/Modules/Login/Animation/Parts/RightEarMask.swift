//
//  右耳遮罩动画部分,需要遮住要不然执行耳朵动画耳朵会露出来
//  Created by 福尔摩翔 on 2022/12/5.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//

import SwiftUI
final class RightEarMask: UIImageView, CritterAnimatable {

    convenience init() {
        self.init(image: UIImage.Critter.head)
        layer.anchorPoint = CGPoint(x: 0, y: 0)
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let superview = superview else { return }

        frame = superview.bounds
        mask = {
            let mask = UIView()
            mask.backgroundColor = .black
            var frame = superview.bounds
            frame.origin.x = frame.midX
            frame.size.width = frame.width / 2
            mask.frame = frame
            return mask
        }()
    }

    // MARK: - CritterAnimatable
    func applyActiveStartState() {
        layer.transform = CATransform3D
            .identity
            .scale(.x, by: 0.82)
    }

    func applyActiveEndState() {
        layer.transform = .identity
    }
}
