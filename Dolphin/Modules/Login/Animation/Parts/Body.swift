//
//  身体动画部分
//  Created by 福尔摩翔 on 2022/12/5.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//

import SwiftUI
final class Body: UIImageView, CritterAnimatable {
    
    convenience init() {
        self.init(image: UIImage.Critter.body)
        layer.zPosition = -30
        frame = CGRect(x: 33.9, y: 109.2, width: 92.1, height: 73.4)
    }
    
    // MARK: - CritterAnimatable
    func applyActiveStartState() {
        layer.transform = CATransform3D
            .identity
            .perspective()
            .rotate(.y, by: -12.degrees)
    }
    
    func applyActiveEndState() {
        layer.transform = CATransform3D
            .identity
            .perspective()
            .rotate(.y, by: 12.degrees)
    }
}
