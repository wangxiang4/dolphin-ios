//
//  设置表格自定义开关列视图模型
//  Created by wangxiang4 on 2022/11/29.
//  Copyright © 2022 entfrm All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SettingSwitchCellViewModel: DefaultTableViewCellViewModel {

    let isEnabled = BehaviorRelay<Bool>(value: false)

    let switchChanged = PublishSubject<Bool>()

    init(with title: String, detail: String?, image: UIImage?, hidesDisclosure: Bool, isEnabled: Bool) {
        super.init()
        self.title.accept(title)
        self.secondDetail.accept(detail)
        self.image.accept(image)
        self.hidesDisclosure.accept(hidesDisclosure)
        self.isEnabled.accept(isEnabled)
    }
}
