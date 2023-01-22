//
//  幻灯片图片预览视图
//  Created by wangxiang4 on 2022/12/20.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import ImageSlideshow

class SlideImageView: ImageSlideshow {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        contentScaleMode = .scaleAspectFit
        contentMode = .scaleAspectFill
        theme.backgroundColor = themeService.attribute { $0.primaryDark }
        borderWidth = Configs.BaseComponentDimensions.borderWidth
        borderColor = .white
        theme.tintColor = themeService.attribute { $0.secondary }
        slideshowInterval = 3
        activityIndicator = DefaultActivityIndicator(style: .white, color: UIColor.secondary())
    }

    func setSources(sources: [URL]) {
        setImageInputs(sources.map({ (url) -> KingfisherSource in
            KingfisherSource(url: url)
        }))
    }

    func present(from controller: UIViewController) {
        self.presentFullScreenController(from: controller)
    }
}
