//
//  设置表格自定义开关列视图
//  Created by wangxiang4 on 2022/11/29.
//  Copyright © 2022 entfrm All rights reserved.
//

import SwiftUI

class SettingSwitchCell: DefaultTableViewCell {

    lazy var switchView: Switch = {
        let view = Switch()
        return view
    }()

    override func makeUI() {
        super.makeUI()
        leftImageView.contentMode = .center
        leftImageView.cornerRadius = 0
        leftImageView.snp.updateConstraints { (make) in
            make.size.equalTo(30)
        }
        stackView.insertArrangedSubview(switchView, at: 2)
        leftImageView.theme.tintColor = themeService.attribute { $0.secondary }
    }

    override func bind(to viewModel: TableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? SettingSwitchCellViewModel else { return }
        viewModel.isEnabled.asDriver().drive(switchView.rx.isOn).disposed(by: rx.disposeBag)
        switchView.rx.isOn.bind(to: viewModel.switchChanged).disposed(by: rx.disposeBag)
    }
}
