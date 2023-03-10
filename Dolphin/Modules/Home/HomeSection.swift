//
//  渲染自定义表格列
//  Created by wangxiang4 on 2022/11/29.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import Foundation
import RxDataSources

enum HomeSection {
    case setting(title: String, items: [HomeSectionItem])
}

enum HomeSectionItem {
    // 消息通知
    case notificationItem(viewModel: HomeCellViewModel)
    
    // 闪光灯通知
    case flashItem(viewModel: HomeCellViewModel)
    
    // 震动反馈
    case vibrationItem(viewModel: HomeCellViewModel)
    
    // 语音播报
    case voiceItem(viewModel: HomeCellViewModel)
    
    // 跳转软件设置
    case settingsItem(viewModel: HomeCellViewModel)
    
    // 打开照相机
    case cameraItem(viewModel: HomeCellViewModel)
    
    // 打开相册
    case albumItem(viewModel: HomeCellViewModel)
}

// 扩展类比较
extension HomeSectionItem: IdentifiableType {
    typealias Identity = String
    var identity: Identity {
        switch self {
        case .notificationItem(let viewModel),
             .flashItem(let viewModel),
             .vibrationItem(let viewModel),
             .voiceItem(let viewModel),
             .settingsItem(let viewModel),
             .cameraItem(let viewModel),
             .albumItem(let viewModel): return viewModel.title.value ?? ""
        }
    }
}

extension HomeSectionItem: Equatable {
    static func == (lhs: HomeSectionItem, rhs: HomeSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}

// 扩展表格科目分类数据源
extension HomeSection: AnimatableSectionModelType, IdentifiableType {
    typealias Item = HomeSectionItem
    typealias Identity = String
    var identity: Identity { return title }

    var title: String {
        switch self {
        case .setting(let title, _): return title
        }
    }

    var items: [HomeSectionItem] {
        switch  self {
        case .setting(_, let items): return items.map {$0}
        }
    }

    init(original: HomeSection, items: [Item]) {
        switch original {
        case .setting(let title, let items): self = .setting(title: title, items: items)
        }
    }
}
