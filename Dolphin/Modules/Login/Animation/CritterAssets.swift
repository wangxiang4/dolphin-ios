//
//  动物动画图片资源
//  Created by wangxiang4 on 2022/12/13.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import SwiftUI
extension UIImage {

    struct Critter {
        static let body = #imageLiteral(resourceName: "icon_login_body")
        static let doeEye = #imageLiteral(resourceName: "icon_login_eye_doe")
        static let eye = #imageLiteral(resourceName: "icon_login_eye")
        static let head = #imageLiteral(resourceName: "icon_login_head")
        static let leftArm = #imageLiteral(resourceName: "icon_login_arm")
        static let leftEar = #imageLiteral(resourceName: "icon_login_ear")
        static let mouthCircle = #imageLiteral(resourceName: "icon_login_mouth_circle")
        static let mouthFull = #imageLiteral(resourceName: "icon_login_mouth_full")
        static let mouthHalf = #imageLiteral(resourceName: "icon_login_mouth_half")
        static let mouthSmile = #imageLiteral(resourceName: "icon_login_mouth_smile")
        static let muzzle = #imageLiteral(resourceName: "icon_login_mouth_muzzle")
        static let nose = #imageLiteral(resourceName: "icon_login_mouth_nose")
        static let rightEar: UIImage = {
            let leftEar = UIImage.Critter.leftEar
            return UIImage(
                cgImage: leftEar.cgImage!,
                scale: leftEar.scale,
                orientation: .upMirrored
            )
        }()
        static let rightArm: UIImage = {
            let leftArm = UIImage.Critter.leftArm
            return UIImage(
                cgImage: leftArm.cgImage!,
                scale: leftArm.scale,
                orientation: .upMirrored
            )
        }()
    }
}
