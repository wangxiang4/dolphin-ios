//
//  基础视图控制器数据绑定,初始化默认配置
//  Created by wangxiang4 on 2022/11/27.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import SwiftUI
import RxSwift
import RxCocoa
import DZNEmptyDataSet
import Hero
import Localize_Swift
import SVProgressHUD

class ViewController: UIViewController {

    init(viewModel: ViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    // 视图模型双向绑定
    var viewModel: ViewModel?
    
    // 状态栏网络加载
    let isLoading = BehaviorRelay(value: false)

    // 是否显示调式工具
    var canOpenFlex = true

    // 设置导航栏标题
    var navigationTitle = "" {
        didSet {
            navigationItem.title = navigationTitle
        }
    }
    
    // 空数据集点击回调
    let emptyDataSetButtonTap = PublishSubject<Void>()
    // 空数据集标题
    var emptyDataSetTitle = R.string.localizable.commonNoResults.key.localized()
    // 空数据集描述
    var emptyDataSetDescription = ""
    // 空数据集图片
    var emptyDataSetImage = R.image.image_no_result()

    // 语言修改回调
    let languageChanged = BehaviorRelay<Void>(value: ())
    // 方向变化回调
    let orientationEvent = PublishSubject<Void>()
    // 抖动回调
    let motionShakeEvent = PublishSubject<Void>()

    // 搜索栏
    lazy var searchBar: SearchBar = {
        let view = SearchBar()
        return view
    }()

    // 退回按钮
    lazy var backBarButton: BarButtonItem = {
        let view = BarButtonItem()
        view.title = ""
        return view
    }()

    // 关闭按钮
    lazy var closeBarButton: BarButtonItem = {
        let view = BarButtonItem(image: R.image.icon_navigation_close(),
                                 style: .plain,
                                 target: self,
                                 action: nil)
        return view
    }()

    // 内容视图
    lazy var contentView: View = {
        let view = View()
        self.view.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        return view
    }()

    // 栈堆布局
    lazy var stackView: StackView = {
        let subviews: [UIView] = []
        let view = StackView(arrangedSubviews: subviews)
        view.spacing = 0
        self.contentView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return view
    }()

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bindViewModel()
        // 关闭当前场景
        closeBarButton.rx.tap.asObservable().subscribe(onNext: { [weak self] () in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: rx.disposeBag)
        // 观察设备方向变化
        NotificationCenter.default
            .rx.notification(UIDevice.orientationDidChangeNotification).mapToVoid()
            .bind(to: orientationEvent).disposed(by: rx.disposeBag)
        // 观察应用程序确实更改了语言通知
        NotificationCenter.default
            .rx.notification(NSNotification.Name(LCLLanguageChangeNotification))
            .subscribe { [weak self] (event) in
                self?.languageChanged.accept(())
            }.disposed(by: rx.disposeBag)
        // 打开Flex的一个手指滑动手势
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleOneFingerSwipe(swipeRecognizer:)))
        swipeGesture.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(swipeGesture)
        // 用于打开Flex和Hero debug的两个手指滑动手势
        let twoSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleTwoFingerSwipe(swipeRecognizer:)))
        twoSwipeGesture.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(twoSwipeGesture)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustLeftBarButtonItem()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logResourcesCount()
    }

    deinit {
        logDebug("\(type(of: self)): 初始化完成!")
        logResourcesCount()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        logDebug("\(type(of: self)): Received Memory Warning")
    }

    // 渲染ui与数据绑定
    func makeUI() {
        navigationItem.backBarButtonItem = backBarButton
        motionShakeEvent.subscribe(onNext: { () in
            nightModeEnabled.accept(!ThemeType.currentTheme().isDark)
        }).disposed(by: rx.disposeBag)
        view.theme.backgroundColor = themeService.attribute { $0.primaryDark }
        backBarButton.theme.tintColor = themeService.attribute { $0.secondary }
        closeBarButton.theme.tintColor = themeService.attribute { $0.secondary }
    }

    func bindViewModel() {
        viewModel?.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)
        languageChanged.subscribe(onNext: { [weak self] () in
            self?.emptyDataSetTitle = R.string.localizable.commonNoResults.key.localized()
        }).disposed(by: rx.disposeBag)
        isLoading.subscribe(onNext: { isLoading in
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
        }).disposed(by: rx.disposeBag)
    }

    // 绘制SVP进度条
    func startAnimating() {
        SVProgressHUD.show()
    }

    // 关闭SVP进度条
    func stopAnimating() {
        SVProgressHUD.dismiss()
    }

    // 抖动结束回调
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            motionShakeEvent.onNext(())
        }
    }
    
    // 调整导航项
    func adjustLeftBarButtonItem() {
        // 第一个栈堆不显示后退按钮
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            self.navigationItem.leftBarButtonItem = nil
        // 除第一个栈堆都显示后退按钮
        } else if self.presentingViewController != nil {
            self.navigationItem.leftBarButtonItem = closeBarButton
        }
    }

    @objc func closeAction(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ViewController {

    var inset: CGFloat {
        return Configs.BaseComponentDimensions.inset
    }

    @objc func handleOneFingerSwipe(swipeRecognizer: UISwipeGestureRecognizer) {
        if swipeRecognizer.state == .recognized, canOpenFlex {
            let libsManager: LibsManager = DIContainer.shared.resolve()
            libsManager.showFlex()
        }
    }

    @objc func handleTwoFingerSwipe(swipeRecognizer: UISwipeGestureRecognizer) {
        if swipeRecognizer.state == .recognized {
            let libsManager: LibsManager = DIContainer.shared.resolve()
            libsManager.showFlex()
            HeroDebugPlugin.isEnabled = !HeroDebugPlugin.isEnabled
        }
    }
}

extension ViewController: DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: emptyDataSetTitle)
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: emptyDataSetDescription)
    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return emptyDataSetImage
    }

    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return .clear
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -60
    }
}

extension ViewController: DZNEmptyDataSetDelegate {

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return !isLoading.value
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }

    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        emptyDataSetButtonTap.onNext(())
    }
}
