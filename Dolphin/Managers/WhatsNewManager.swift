//
//  程序新功能特性管理
//  采用RxTheme全局ui组件监听切换
//  Created by 福尔摩翔 on 2022/12/5.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//

import WhatsNewKit

typealias WhatsNewBlock = (WhatsNew, WhatsNewConfiguration, KeyValueWhatsNewVersionStore?)
typealias WhatsNewConfiguration = WhatsNewViewController.Configuration

class WhatsNewManager: NSObject {
    
    func whatsNew(trackVersion track: Bool = true) -> WhatsNewBlock {
        return (items(), configuration(), track ? versionStore(): nil)
    }

    // 新功能列表
    private func items() -> WhatsNew {
        let whatsNew = WhatsNew(
            title: R.string.localizable.whatsNewTitle.key.localized(),
            items: [
                WhatsNew.Item(title: R.string.localizable.whatsNewItem4Title.key.localized(),
                              subtitle: R.string.localizable.whatsNewItem4Subtitle.key.localized(),
                              image: R.image.icon_whatsnew_trending()),
                WhatsNew.Item(title: R.string.localizable.whatsNewItem1Title.key.localized(),
                              subtitle: R.string.localizable.whatsNewItem1Subtitle.key.localized(),
                              image: R.image.icon_whatsnew_cloc()),
                WhatsNew.Item(title: R.string.localizable.whatsNewItem2Title.key.localized(),
                              subtitle: R.string.localizable.whatsNewItem2Subtitle.key.localized(),
                              image: R.image.icon_whatsnew_theme()),
                WhatsNew.Item(title: R.string.localizable.whatsNewItem3Title.key.localized(),
                              subtitle: R.string.localizable.whatsNewItem3Subtitle.key.localized(),
                              image: R.image.icon_whatsnew_cloc())
            ])
        return whatsNew
    }

    // 新功能配置
    private func configuration() -> WhatsNewViewController.Configuration {
        var configuration = WhatsNewViewController.Configuration(
            completionButton: .init(stringLiteral: R.string.localizable.whatsNewCompletionButtonTitle.key.localized())
        )
        configuration.itemsView.imageSize = .original
        configuration.apply(animation: .slideRight)
        if ThemeType.currentTheme().isDark {
            configuration.apply(theme: .darkRed)
            configuration.backgroundColor = .primaryDark()
        } else {
            configuration.apply(theme: .whiteRed)
            configuration.backgroundColor = .white
        }
        return configuration
    }

    // 保存版本,可通过使用您的捆绑包的当前版本初始化WhatsNew版本
    // https://github.com/SvenTiigi/WhatsNewKit/tree/main
    private func versionStore() -> KeyValueWhatsNewVersionStore {
        let versionStore = KeyValueWhatsNewVersionStore(keyValueable: UserDefaults.standard, prefixIdentifier: Configs.App.bundleIdentifier)
        return versionStore
    }
}
