//
//  设置表格自定义基础列视图
//  Created by wangxiang4 on 2022/11/29.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import SwiftUI
class SettingCell: DefaultTableViewCell {

    override func makeUI() {
        super.makeUI()
        leftImageView.contentMode = .center
        leftImageView.cornerRadius = 0
        leftImageView.snp.updateConstraints { (make) in
            make.size.equalTo(30)
        }
        detailLabel.isHidden = true
        attributedDetailLabel.isHidden = true
        secondDetailLabel.textAlignment = .right
        textsStackView.axis = .horizontal
        textsStackView.distribution = .fillEqually
    }
}
