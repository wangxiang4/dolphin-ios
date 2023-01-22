//
//  全局应用配置
//  Created by 福尔摩翔 on 2022/12/5.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//

import SwiftUI
struct Configs {

    // APP配置
    struct App {
        static let baseUrl = "http://120.26.168.56:9999"
        static let gatewayAseEncodeSecret = "changsha-kanglai"
        static let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? "KanglaiCall"
    }
    
    // 缓存键配置
    struct CacheKey {
        static let tokenEnhancerKey = "ENTFRM_TOKEN_KEY"
        static let userInfoKey = "ENTFRM_USER_INFO_KEY"
        static let firstLoadKey = "FIRST_LOAD_KEY"
    }

    // 基础组件尺寸配置
    struct BaseComponentDimensions {
        static let inset: CGFloat = 8
        static let tabBarHeight: CGFloat = 58
        static let toolBarHeight: CGFloat = 66
        static let navBarWithStatusBarHeight: CGFloat = 64
        static let cornerRadius: CGFloat = 5
        static let borderWidth: CGFloat = 1
        static let buttonHeight: CGFloat = 40
        static let textFieldHeight: CGFloat = 40
        static let tableRowHeight: CGFloat = 36
        static let segmentedControlHeight: CGFloat = 40
    }

}
