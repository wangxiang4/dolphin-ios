//
//  通知表格自定义基础列视图模型
//  Created by wangxiang4 on 2022/11/29.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MessageCellViewModel: DefaultTableViewCellViewModel {

    // 行数据
    let ossFile: OSSFile?
    
    // 行点击
    let rowSelected = PublishSubject<OSSFile>()
    
    init(with ossFile: OSSFile) {
        self.ossFile = ossFile
        super.init()
        // 设置列数据
        title.accept(ossFile.original)
        detail.accept(ossFile.createTime)
        image.accept(R.image.icon_cell_submodule()?.template)
        hidesDisclosure.accept(true)
    }
    
}
