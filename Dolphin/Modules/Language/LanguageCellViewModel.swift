//
//  设置国际化语言自定义基础列视图模型
//  Created by wangxiang4 on 2022/11/29.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LanguageCellViewModel: DefaultTableViewCellViewModel {

    let language: String

    init(with language: String) {
        self.language = language
        super.init()
        title.accept(displayName(forLanguage: language))
    }
}

func displayName(forLanguage language: String) -> String {
    let local = Locale(identifier: language)
    if let displayName = local.localizedString(forIdentifier: language) {
        return displayName.capitalized(with: local)
    }
    return String()
}
