//
//  默认表格列视图模型
//  Created by wangxiang4 on 2022/11/27.
//  Copyright © 2022 entfrm All rights reserved.
//


import Foundation
import RxSwift
import RxCocoa

class DefaultTableViewCellViewModel: TableViewCellViewModel {
    
    // 标题
    let title = BehaviorRelay<String?>(value: nil)
    
    // 第一行描述
    let detail = BehaviorRelay<String?>(value: nil)
    
    // 第二行描述
    let secondDetail = BehaviorRelay<String?>(value: nil)
    
    // 第三行自定义Label组件视图
    let attributedDetail = BehaviorRelay<NSAttributedString?>(value: nil)
    
    // 左侧图片
    let image = BehaviorRelay<UIImage?>(value: nil)
    
    // 左侧图片url地址
    let imageUrl = BehaviorRelay<String?>(value: nil)
    
    // 徽章图片
    let badge = BehaviorRelay<UIImage?>(value: nil)
    
    // 徽章颜色
    let badgeColor = BehaviorRelay<UIColor?>(value: nil)
    
    // 隐藏右箭头
    let hidesDisclosure = BehaviorRelay<Bool>(value: false)
    
}
