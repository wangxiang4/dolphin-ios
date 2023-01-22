//
//  扩展UI基础视图边界
//  Created by 福尔摩翔 on 2022/12/5.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//

import SwiftUI
import Foundation

// 创建边界
extension UIView {

    enum BorderSide {
        case left, top, right, bottom
    }

    func defaultBorderColor() -> UIColor {
        return UIColor.separator()
    }

    func defaultBorderDepth() -> CGFloat {
        return Configs.BaseComponentDimensions.borderWidth
    }

    // 添加使用默认参数为侧面添加边框
    // @Param side 边界侧
    // Returns: 边界视图
    @discardableResult
    func addBorder(for side: BorderSide) -> UIView {
        return addBorder(for: side, color: defaultBorderColor(), depth: defaultBorderDepth())
    }

    // 添加使用默认参数添加底部边框
    // @Param leftInset: 左偏移量
    // @Param rightInset: 右偏移量
    // Returns: 边界视图
    @discardableResult
    func addBottomBorder(leftInset: CGFloat = 10, rightInset: CGFloat = 0) -> UIView {
        let border = UIView()
        border.backgroundColor = defaultBorderColor()
        self.addSubview(border)
        border.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(leftInset)
            make.right.equalToSuperview().inset(rightInset)
            make.bottom.equalToSuperview()
            make.height.equalTo(self.defaultBorderDepth())
        }
        return border
    }

    // 添加带有颜色、深度、长度和偏移量的侧面边框
    // @Param side: 边界侧
    // @Param color: 边界颜色
    // @Param depth: 边界宽度
    // @Param length: 边界长度
    // @Param inset: 边界偏移量
    // @Param cornersInset: 边界对角偏移量
    // Returns: 边界视图
    @discardableResult
    func addBorder(for side: BorderSide, color: UIColor, depth: CGFloat, length: CGFloat = 0.0, inset: CGFloat = 0.0, cornersInset: CGFloat = 0.0) -> UIView {
        let border = UIView()
        border.backgroundColor = color
        self.addSubview(border)
        border.snp.makeConstraints { (make) in
            switch side {
            case .left:
                if length != 0.0 {
                    make.height.equalTo(length)
                    make.centerY.equalToSuperview()
                } else {
                    make.top.equalToSuperview().inset(cornersInset)
                    make.bottom.equalToSuperview().inset(cornersInset)
                }
                make.left.equalToSuperview().inset(inset)
                make.width.equalTo(depth)
            case .top:
                if length != 0.0 {
                    make.width.equalTo(length)
                    make.centerX.equalToSuperview()
                } else {
                    make.left.equalToSuperview().inset(cornersInset)
                    make.right.equalToSuperview().inset(cornersInset)
                }
                make.top.equalToSuperview().inset(inset)
                make.height.equalTo(depth)
            case .right:
                if length != 0.0 {
                    make.height.equalTo(length)
                    make.centerY.equalToSuperview()
                } else {
                    make.top.equalToSuperview().inset(cornersInset)
                    make.bottom.equalToSuperview().inset(cornersInset)
                }
                make.right.equalToSuperview().inset(inset)
                make.width.equalTo(depth)
            case .bottom:
                if length != 0.0 {
                    make.width.equalTo(length)
                    make.centerX.equalToSuperview()
                } else {
                    make.left.equalToSuperview().inset(cornersInset)
                    make.right.equalToSuperview().inset(cornersInset)
                }
                make.bottom.equalToSuperview().inset(inset)
                make.height.equalTo(depth)
            }
        }
        return border
    }
}
