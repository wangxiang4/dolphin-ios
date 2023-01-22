//
//  左耳动画部分
//  Created by 福尔摩翔 on 2022/12/5.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//

import SwiftUI
final class LeftEar: UIImageView, CritterAnimatable {
    
    convenience init() {
        self.init(image: UIImage.Critter.leftEar)
        frame = CGRect(x: -9.1, y: -3.3, width: 36.6, height: 36.6)
    }
    
    // MARK: - CritterAnimatable
    func applyActiveStartState() {
        layer.transform = CATransform3D
            .identity
            .translate(.x, by: 10)
    }
    
    func applyActiveEndState() {
        layer.transform = CATransform3D
            .identity
            .translate(.x, by: 2)
            .translate(.y, by: 12)
            .rotate(.z, by: -8.0.degrees)
    }
}
