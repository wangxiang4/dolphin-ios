//
//  设置表格自定义基础列视图模型
//  Created by wangxiang4 on 2022/11/29.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UserCellViewModel: DefaultTableViewCellViewModel {

    init(with title: String, detail: String?, image: UIImage?, hidesDisclosure: Bool) {
        super.init()
        self.title.accept(title)
        self.secondDetail.accept(detail)
        self.image.accept(image)
        self.hidesDisclosure.accept(hidesDisclosure)
    }
}
