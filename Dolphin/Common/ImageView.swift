//
//  图片视图rx-ui数据绑定,初始化默认配置
//  Created by 福尔摩翔 on 2022/11/27.
//  Copyright © 2022 entfrm All rights reserved.
//

import SwiftUI

class ImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    override init(image: UIImage?) {
        super.init(image: image)
        makeUI()
    }

    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    // 渲染ui与数据绑定
    func makeUI() {
        tintColor = .primary()
        layer.masksToBounds = true
        contentMode = .center
        setNeedsDisplay()
    }

}
