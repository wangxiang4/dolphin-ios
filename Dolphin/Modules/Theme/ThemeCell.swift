//
//  设置主题颜色自定义基础列视图
//  Created by wangxiang4 on 2022/11/29.
//  Copyright © 2022 entfrm All rights reserved.
//

import SwiftUI

class ThemeCell: DefaultTableViewCell {

    override func makeUI() {
        super.makeUI()
        rightImageView.isHidden = true
    }

    override func bind(to viewModel: TableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? ThemeCellViewModel else { return }

        viewModel.imageColor.asDriver().drive(leftImageView.rx.backgroundColor).disposed(by: rx.disposeBag)
    }
}
