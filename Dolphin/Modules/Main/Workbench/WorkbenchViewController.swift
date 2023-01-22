//
//  工作台视图控制器
//  Created by 福尔摩翔 on 2022/11/29.
//  Copyright © 2022 entfrm All rights reserved.
//

import SwiftUI
import RxSwift
import RxCocoa

class WorkbenchViewController: ViewController {
    
    // 头部布局
    lazy var headContentView: View = {
        let view = View()
        self.stackView.insertArrangedSubview(view, at: 0)
        view.snp.makeConstraints { (make) in
    
            make.height.equalTo(200)
            make.leftMargin.rightMargin.equalTo(self.inset)
              
        }
        return view
    }()
    
    // 中心布局
    lazy var bodyContentView: View = {
        let view = View()
        self.stackView.insertArrangedSubview(view, at: 1)
        view.snp.makeConstraints { (make) in
            make.height.equalTo(200)
            //make.edges.equalToSuperview().inset(UIEdgeInsets(horizontal: self.inset, vertical: self.inset/2))
        }
        return view
    }()
    
    // 底部布局
    lazy var footerContentView: View = {
        let view = View()
        self.stackView.insertArrangedSubview(view, at: 2)
        view.snp.makeConstraints { (make) in
            make.height.equalTo(200)
            //make.edges.equalToSuperview().inset(UIEdgeInsets(horizontal: self.inset, vertical: self.inset/2))
        }
        return view
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.cornerRadius = 20
        imageView.image = UIImage(named: "icon_user_tom")
        let url = URL(string: "https://github.com/wangxiang4/loquat-form-design/raw/master/public/image/sample1.gif")
        imageView.kf.setImage(with: url)
        return imageView
    }()
    
    lazy var tilte: UILabel = {
        let label = UILabel()
        label.theme.textColor = themeService.attribute { $0.text }
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "功能正在开发中"
        return label
    }()
    
    override func makeUI() {
        super.makeUI()
        languageChanged.subscribe(onNext: { [weak self] () in
            self?.navigationTitle = R.string.localizable.homeTabBarWorkbenchTitle.key.localized()
        }).disposed(by: rx.disposeBag)
        
//        headContentView.addSubview(self.imageView)
//        self.imageView.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(100)
//            make.width.height.equalTo(200)
//        }
        
        headContentView.addSubview(self.tilte)
        self.tilte.snp.makeConstraints { (make) in
            //make.centerX.equalToSuperview()
        }
       
//        bodyContentView.addSubview(self.imageView)
//        self.imageView.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(100)
//            make.width.height.equalTo(200)
//        }
//
        bodyContentView.addSubview(self.tilte)
        self.tilte.snp.makeConstraints { (make) in
            //make.centerX.equalToSuperview()
            //make.bottom.equalTo(imageView.snp.bottom).offset(50)
        }
//
//
//        footerContentView.addSubview(self.imageView)
//        self.imageView.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(100)
//            make.width.height.equalTo(200)
//        }
//
        footerContentView.addSubview(self.tilte)
        self.tilte.snp.makeConstraints { (make) in
            //make.centerX.equalToSuperview()
            //make.bottom.equalTo(imageView.snp.bottom).offset(50)
        }
        
        
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? WorkbenchViewModel else { return }
    }
}
