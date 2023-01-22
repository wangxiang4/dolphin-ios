//
//  设置国际化语言自定义基础列视图
//  Created by wangxiang4 on 2022/11/29.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import SwiftUI

class LanguageCell: DefaultTableViewCell {

    override func makeUI() {
        super.makeUI()
        leftImageView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        rightImageView.image = selected ? R.image.icon_cell_check()?.template : nil
    }
}
