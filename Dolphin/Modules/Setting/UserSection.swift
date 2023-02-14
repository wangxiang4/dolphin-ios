//
//  渲染自定义表格列
//  Created by wangxiang4 on 2022/11/29.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import Foundation
import RxDataSources

enum UserSection {
    case setting(title: String, items: [UserSectionItem])
}

enum UserSectionItem {

    // 夜间模式
    case nightModeItem(viewModel: UserSwitchCellViewModel)
    
    // 切换主题颜色
    case themeItem(viewModel: UserCellViewModel)
    
    // 切换国际化语言
    case languageItem(viewModel: UserCellViewModel)
    
    // 清除图片缓存
    case removeCacheItem(viewModel: UserCellViewModel)
    
    // 新特性
    case whatsNewItem(viewModel: UserCellViewModel)
    
    // 登出
    case logoutItem(viewModel: UserCellViewModel)
}

extension UserSectionItem: IdentifiableType {
    typealias Identity = String
    var identity: Identity {
        switch self {
        case .nightModeItem(let viewModel): return viewModel.title.value ?? ""
        case .themeItem(let viewModel),
             .languageItem(let viewModel),
             .removeCacheItem(let viewModel),
             .whatsNewItem(let viewModel),
             .logoutItem(let viewModel): return viewModel.title.value ?? ""
        }
    }
}

extension UserSectionItem: Equatable {
    static func == (lhs: UserSectionItem, rhs: UserSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}

extension UserSection: AnimatableSectionModelType, IdentifiableType {
    typealias Item = UserSectionItem

    typealias Identity = String
    var identity: Identity { return title }

    var title: String {
        switch self {
        case .setting(let title, _): return title
        }
    }

    var items: [UserSectionItem] {
        switch  self {
        case .setting(_, let items): return items.map {$0}
        }
    }

    init(original: UserSection, items: [Item]) {
        switch original {
        case .setting(let title, let items): self = .setting(title: title, items: items)
        }
    }
}
