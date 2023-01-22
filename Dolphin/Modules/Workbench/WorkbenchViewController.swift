//
//  工作台视图控制器
//  Created by wangxiang4 on 2022/11/29.
//  Copyright © 2022 entfrm All rights reserved.
//

import SwiftUI
import RxSwift
import RxCocoa
import Toast_Swift
import ImageSlideshow

class WorkbenchViewController: ViewController {
    
    // 底板层头部布局
    lazy var floorHeadContentView: View = {
        let view = View()
        self.stackView.insertArrangedSubview(view, at: 0)
        view.snp.makeConstraints { (make) in
            make.height.equalTo(180)
        }
        return view
    }()
    
    // 底板层中心布局
    lazy var floorBodyContentView: View = {
        let view = View()
        self.stackView.insertArrangedSubview(view, at: 1)
        return view
    }()
    
    // 底板层底部布局
    lazy var floorFooterContentView: View = {
        let view = View()
        self.stackView.insertArrangedSubview(view, at: 2)
        view.snp.makeConstraints { (make) in
            make.height.equalTo(100)
        }
        return view
    }()
    
    // 头部布局
    lazy var headContentView: View = {
        let view = View()
        return view
    }()
    
    // 中心布局
    lazy var bodyContentView: View = {
        let view = View()
        return view
    }()
    
    // 底部布局
    lazy var footerContentView: View = {
        let view = View()
        return view
    }()
    
    lazy var oaButtonView1: View = {
        
        // 堆栈视图底板层
        let floorContentView = View()
        
        let imageView = ImageView()
        imageView.theme.tintColor = themeService.attribute { $0.secondary }
        imageView.image = R.image.icon_oa_button1()?.template
        floorContentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(55)
        }
        
        let labelView = Label()
        labelView.theme.textColor = themeService.attribute { $0.text }
        labelView.font = UIFont.boldSystemFont(ofSize: 13)
        labelView.text = "请假申请"
        floorContentView.addSubview(labelView)
        labelView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(imageView.snp.bottom).offset(14)
        }

        return floorContentView
    }()

    lazy var oaButtonView2: View = {
        
        // 堆栈视图底板层
        let floorContentView = View()
        
        let imageView = ImageView()
        imageView.theme.tintColor = themeService.attribute { $0.secondary }
        imageView.image = R.image.icon_oa_button2()?.template
        floorContentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(55)
        }
        
        let labelView = Label()
        labelView.theme.textColor = themeService.attribute { $0.text }
        labelView.font = UIFont.boldSystemFont(ofSize: 13)
        labelView.text = "加班申请"
        floorContentView.addSubview(labelView)
        labelView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(imageView.snp.bottom).offset(14)
        }

        return floorContentView
    }()
    
    lazy var oaButtonView3: View = {
        
        // 堆栈视图底板层
        let floorContentView = View()
        
        let imageView = ImageView()
        imageView.theme.tintColor = themeService.attribute { $0.secondary }
        imageView.image = R.image.icon_oa_button3()?.template
        floorContentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(55)
        }
        
        let labelView = Label()
        labelView.theme.textColor = themeService.attribute { $0.text }
        labelView.font = UIFont.boldSystemFont(ofSize: 13)
        labelView.text = "出差申请"
        floorContentView.addSubview(labelView)
        labelView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(imageView.snp.bottom).offset(14)
        }

        return floorContentView
    }()
    
    lazy var oaButtonView4: View = {
        
        // 堆栈视图底板层
        let floorContentView = View()
        
        let imageView = ImageView()
        imageView.theme.tintColor = themeService.attribute { $0.secondary }
        imageView.image = R.image.icon_oa_button4()?.template
        floorContentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(55)
        }
        
        let labelView = Label()
        labelView.theme.textColor = themeService.attribute { $0.text }
        labelView.font = UIFont.boldSystemFont(ofSize: 14)
        labelView.text = "离职申请"
        floorContentView.addSubview(labelView)
        labelView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(imageView.snp.bottom).offset(14)
        }

        return floorContentView
    }()
    
    // OA办公堆栈视图,第一列,xxx: 临时处理,后面按钮多要更换Table网格组件布局
    lazy var oAStackView1: StackView = {
        let subviews: [UIView] = []
        let view = StackView(arrangedSubviews: subviews)
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fillEqually
        view.spacing = 15
        self.bodyContentView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.height.equalTo(75)
            make.width.equalToSuperview()
        })
        return view
    }()
    
    lazy var copyright: UILabel = {
        let label = UILabel()
        label.theme.textColor = themeService.attribute { $0.textGray }
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "康来研发中心移动审批工作台"
        return label
    }()
    
    lazy var slideImageView: SlideImageView = {
        let view = SlideImageView()
        view.borderWidth = 0
        view.cornerRadius = 20
        view.contentScaleMode = .scaleToFill
        view.setImageInputs([
            ImageSource(image: UIImage(named: "icon_oa_slideImage1")!),
            ImageSource(image: UIImage(named: "icon_oa_slideImage2")!),
            ImageSource(image: UIImage(named: "icon_oa_slideImage3")!),
            ImageSource(image: UIImage(named: "icon_oa_slideImage4")!),
            ImageSource(image: UIImage(named: "icon_oa_slideImage5")!),
            ImageSource(image: UIImage(named: "icon_oa_slideImage6")!),
            ImageSource(image: UIImage(named: "icon_oa_slideImage7")!)
        ])
        return view
    }()
    
    override func makeUI() {
        super.makeUI()
        languageChanged.subscribe(onNext: { [weak self] () in
            self?.navigationTitle = R.string.localizable.homeTabBarWorkbenchTitle.key.localized()
        }).disposed(by: rx.disposeBag)
        
        floorHeadContentView.addSubview(self.headContentView)
        self.headContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(horizontal: self.inset, vertical: 0))
        }
        
        floorBodyContentView.addSubview(self.bodyContentView)
        self.bodyContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: inset, left: inset, bottom: 0, right: inset))
        }
        
        floorFooterContentView.addSubview(self.footerContentView)
        self.footerContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(horizontal: self.inset, vertical: 0))
        }
        
        headContentView.addSubview(self.slideImageView)
        self.slideImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        footerContentView.addSubview(self.copyright)
        self.copyright.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(18)
            make.centerX.equalToSuperview()
        }
        
        // OA办公按钮视图布局
        oAStackView1.addArrangedSubview(self.oaButtonView1)
        oaButtonView1.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
        oAStackView1.addArrangedSubview(self.oaButtonView2)
        oaButtonView2.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
        oAStackView1.addArrangedSubview(self.oaButtonView3)
        oaButtonView3.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
        oAStackView1.addArrangedSubview(self.oaButtonView4)
        oaButtonView4.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
        // 点击回调处理
        oaButtonView1.rx.tap().asObservable().subscribe(onNext: { [weak self] () in
            var style = ToastManager.shared.style
            style.backgroundColor = UIColor.Material.green
            self?.view.makeToast("你刚刚点击了OA请假申请", position: .top, style: style)
        }).disposed(by: rx.disposeBag)
        
        oaButtonView2.rx.tap().asObservable().subscribe(onNext: { [weak self] () in
            var style = ToastManager.shared.style
            style.backgroundColor = UIColor.Material.green
            self?.view.makeToast("你刚刚点击了OA加班申请", position: .top, style: style)
        }).disposed(by: rx.disposeBag)
        
        oaButtonView3.rx.tap().asObservable().subscribe(onNext: { [weak self] () in
            var style = ToastManager.shared.style
            style.backgroundColor = UIColor.Material.green
            self?.view.makeToast("你刚刚点击了OA出差申请", position: .top, style: style)
        }).disposed(by: rx.disposeBag)
        
        oaButtonView4.rx.tap().asObservable().subscribe(onNext: { [weak self] () in
            var style = ToastManager.shared.style
            style.backgroundColor = UIColor.Material.green
            self?.view.makeToast("你刚刚点击了OA离职申请", position: .top, style: style)
        }).disposed(by: rx.disposeBag)

    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? WorkbenchViewModel else { return }
    }
}
