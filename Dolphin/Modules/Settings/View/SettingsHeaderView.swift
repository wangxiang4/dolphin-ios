//
//  头部个人用户视图
//  Created by wangxiang4 on 2022/12/10.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import SwiftUI
import Kingfisher

// 事件代理
protocol SettingsHeaderViewDelegate: NSObjectProtocol {
    
    func imgViewClick(imgView: UIImageView)

}

class SettingsHeaderView: UIView {
  
    weak var delegate: SettingsHeaderViewDelegate?
    
    // 内容视图
    lazy var contentView: View = {
        let view = View()
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.height.equalTo(100)
            make.edges.equalToSuperview().inset(UIEdgeInsets(horizontal: self.inset, vertical: self.inset/2))
        }
        return view
    }()
    
    // 头像包装
    var imageViewWrapper: View = {
        let view = View()
        return view
    }()
    
    // 头像
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.cornerRadius = 20
        imageView.image = UIImage(named: "icon_user_tom")
        let url = URL(string: "https://vuejs.godolphinx.org/resource/img/logo.svg")
        imageView.kf.setImage(with: url)
        return imageView
    }()
    
    // 昵称
    lazy var nickName: UILabel = {
        let label = UILabel()
        label.theme.textColor = themeService.attribute { $0.text }
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = User.getUserInfo()?.nickName
        return label
    }()
    
    // 描述
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = User.getUserInfo()?.remarks
        label.theme.textColor = themeService.attribute { $0.text }
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func makeUI() {
        contentView.makeRoundedCorners(20)
        contentView.theme.backgroundColor = themeService.attribute { $0.primary }
        
        // 头像包装布局
        contentView.addSubview(self.imageViewWrapper)
        self.imageViewWrapper.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(90)
            make.left.equalTo(8)
        }
        
        // 头像布局
        self.imageViewWrapper.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        // 昵称布局
        contentView.addSubview(self.nickName)
        self.nickName.snp.makeConstraints { (make) in
            make.left.equalTo(self.imageView.snp.right).offset(8)
            make.top.equalTo(self.imageView.snp.top).offset(15)
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }

        // 描述布局
        contentView.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.nickName)
            make.bottom.equalTo(self.imageView.snp.bottom).offset(-15)
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }

        setAnimationViewAnimation()
        self.imageViewWrapper.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            self.delegate?.imgViewClick(imgView: self.imageView)
        }).disposed(by: rx.disposeBag)
    }
    
    // 头像动态动画, xxx:注意,动画会改变视图的frame导致第一次初始化点击手势失效
    func setAnimationViewAnimation() {
        let opts: UIView.AnimationOptions = [.autoreverse, .repeat]
        UIView.animate(withDuration: 1, delay: 1, options: opts, animations: {
            self.imageView.center.y -= 3
        })
    }
    
}
