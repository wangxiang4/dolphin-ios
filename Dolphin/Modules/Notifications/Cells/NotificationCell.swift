//
//  通知表格自定义基础列视图
//  Created by wangxiang4 on 2022/11/29.
//  Copyright © 2022 entfrm All rights reserved.
//

import SwiftUI
import RxSwift

class NotificationCell: DefaultTableViewCell {
    
    override func makeUI() {
        super.makeUI()
        titleLabel.numberOfLines = 2
        leftImageView.cornerRadius = 0
    }
    
    override func bind(to viewModel: TableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? NotificationCellViewModel else { return }
        
        // 不能使用 rx.disposeBag 重用列,rx销毁冲突
        cellDisposeBag = DisposeBag()
        
        // 行点击绑定回调
        containerView.rx.tap().map { _ in viewModel.ossFile }.filterNil().bind(to: viewModel.rowSelected).disposed(by: cellDisposeBag)
    }

}
