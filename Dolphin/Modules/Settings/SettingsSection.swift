//
//  渲染自定义表格列
//  Created by 福尔摩翔 on 2022/11/29.
//  Copyright © 2022 entfrm All rights reserved.
//

import Foundation
import RxDataSources

enum SettingsSection {
    case setting(title: String, items: [SettingsSectionItem])
}

enum SettingsSectionItem {

    // 夜间模式
    case nightModeItem(viewModel: SettingSwitchCellViewModel)
    
    // 切换主题颜色
    case themeItem(viewModel: SettingCellViewModel)
    
    // 切换国际化语言
    case languageItem(viewModel: SettingCellViewModel)
    
    // 清除图片缓存
    case removeCacheItem(viewModel: SettingCellViewModel)
    
    // 新特性
    case whatsNewItem(viewModel: SettingCellViewModel)
    
    // 登出
    case logoutItem(viewModel: SettingCellViewModel)
}

extension SettingsSectionItem: IdentifiableType {
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

extension SettingsSectionItem: Equatable {
    static func == (lhs: SettingsSectionItem, rhs: SettingsSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}

extension SettingsSection: AnimatableSectionModelType, IdentifiableType {
    typealias Item = SettingsSectionItem

    typealias Identity = String
    var identity: Identity { return title }

    var title: String {
        switch self {
        case .setting(let title, _): return title
        }
    }

    var items: [SettingsSectionItem] {
        switch  self {
        case .setting(_, let items): return items.map {$0}
        }
    }

    init(original: SettingsSection, items: [Item]) {
        switch original {
        case .setting(let title, let items): self = .setting(title: title, items: items)
        }
    }
}
