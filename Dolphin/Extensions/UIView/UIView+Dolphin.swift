//
//  扩展UI基础视图
//  Created by wangxiang4 on 2022/12/5.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import UIKit
import Foundation

extension UIView {

    // 制作圆角布局
    func makeRoundedCorners(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }

    // 制作圆角
    func makeRoundedCorners() {
        makeRoundedCorners(bounds.size.width / 2)
    }

    // 添加模糊视图
    func blur(style: UIBlurEffect.Style) {
        unBlur()
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        insertSubview(blurEffectView, at: 0)
        blurEffectView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }

    // 移除模糊视图
    func unBlur() {
        subviews.filter { (view) -> Bool in
            view as? UIVisualEffectView != nil
        }.forEach { (view) in
            view.removeFromSuperview()
        }
    }
}
