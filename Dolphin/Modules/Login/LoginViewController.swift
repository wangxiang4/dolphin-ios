//
//  登录视图控制器
//  Created by 福尔摩翔 on 2022/12/13.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//

import SwiftUI
import Toast_Swift
import Localize_Swift
import RxSwift
import RxCocoa
import SVProgressHUD

// 按钮绘制控制
private let buttonFrame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
// 按钮高度
private let buttonHeight = textFieldHeight
// 按钮宽度
private let buttonWidth = (textFieldHorizontalMargin / 2) + buttonImageDimension
// 按钮文字水平边距
private let buttonHorizontalMargin = textFieldHorizontalMargin / 2
// 按钮图像尺寸大小
private let buttonImageDimension: CGFloat = 28
// 按钮垂直边距
private let buttonVerticalMargin = (buttonHeight - buttonImageDimension) / 2

// 动物视图尺寸
private let critterViewDimension: CGFloat = 160
// 动物视图绘制控制
private let critterViewFrame = CGRect(x: 0, y: 0, width: critterViewDimension, height: critterViewDimension)
// 动物视图顶部边距
private let critterViewTopMargin: CGFloat = 70

// 文本输入框高度
private let textFieldHeight: CGFloat = 37
// 文本输入框宽度
private let textFieldWidth: CGFloat = 235
// 文本输入框水平边距
private let textFieldHorizontalMargin: CGFloat = 16.5
// 文本输入框上下间距
private let textFieldSpacing: CGFloat = 22
// 文本输入框顶部边距
private let textFieldTopMargin: CGFloat = 38.8

// 颜色主题
struct LoginColorTheme {
    static let text = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 1)
    static let disabledText = LoginColorTheme.text.withAlphaComponent(0.8)
}

final class LoginViewController: UIViewController, UITextFieldDelegate {

    var viewModel: ViewModel?
    
    init(viewModel: ViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    // 抖动回调
    let motionShakeEvent = PublishSubject<Void>()
    
    // 动物视图
    private let critterView = CritterView(frame: critterViewFrame)

    // 用户文本框
    private lazy var usernameTextField: UITextField = {
        let textField = createTextField(text: "请输入用户名")
        textField.keyboardType = .namePhonePad
        textField.returnKeyType = .next
        return textField
    }()

    // 密码文本框
    private lazy var passwordTextField: UITextField = {
        let textField = createTextField(text: "请输入密码")
        textField.isSecureTextEntry = true
        textField.returnKeyType = .go
        textField.rightView = showHidePasswordButton
        showHidePasswordButton.isHidden = true
        return textField
    }()

    // 显示隐藏密码按钮
    private lazy var showHidePasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageEdgeInsets = UIEdgeInsets(top: buttonVerticalMargin, left: 0, bottom: buttonVerticalMargin, right: buttonHorizontalMargin)
        button.frame = buttonFrame
        button.tintColor = LoginColorTheme.text
        button.setImage(#imageLiteral(resourceName: "icon_login_password_show"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "icon_login_password_hide"), for: .selected)
        button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        return button
    }()
    
    // 登录按钮
    private lazy var loginButton: UIButton = {
        let view = Button()
        view.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 15)
        view.imageForNormal = R.image.icon_button_tom()
        view.centerTextAndImage(spacing: Configs.BaseComponentDimensions.inset)
        view.setTitleColor(LoginColorTheme.text, for: .normal)
        view.titleForNormal = "登录"
        view.cornerRadius = 18
        return view
    }()

    // QQ登录
    private lazy var QQlogin: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_login_qq")
        return imageView
    }()
    
    // 微信登录
    private lazy var WeChatlogin: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_login_wechat")
        return imageView
    }()

    // 创建栈堆布局
    lazy var stackView: StackView = {
        let subviews: [UIView] = []
        let stackView = StackView(arrangedSubviews: subviews)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 25
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(view.snp.bottom).offset(-100)
        })
        return stackView
    }()

    private let notificationCenter: NotificationCenter = .default

    deinit {
        // 移除进入后台动物头部旋转
        notificationCenter.removeObserver(self)
        logDebug("\(type(of: self)): 初始化完成!")
        logResourcesCount()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bindViewModel()
    }

    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let deadlineTime = DispatchTime.now() + .milliseconds(100)

        if textField == usernameTextField {
            // 🤪 输入文字开始动物头部旋转动画
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                let fractionComplete = self.fractionComplete(for: textField)
                self.critterView.startHeadRotation(startAt: fractionComplete)
                self.passwordDidResignAsFirstResponder()
            }
        } else if textField == passwordTextField {
            // 👻 输入文字开始动物遮挡脸部动画
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.critterView.isShy = true
                self.showHidePasswordButton.isHidden = false
            }
        }
    }

    // 键盘回车处理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
            passwordDidResignAsFirstResponder()
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == usernameTextField {
            critterView.stopHeadRotation()
        }
    }

    // 文本框修改处理
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard !critterView.isActiveStartAnimating, textField == usernameTextField else { return }

        // 更新动物头部旋转
        let fractionComplete = self.fractionComplete(for: textField)
        critterView.updateHeadRotation(to: fractionComplete)

        // 👻 字符串大于绘制动物狂喜动画
        if let text = textField.text {
            critterView.isEcstatic = text.count > 6
        }
    }

    // 设置登录视图
    private func makeUI() {
        view.theme.backgroundColor = themeService.attribute { $0.loginPrimaryDark }
        
        // 动物视图布局
        view.addSubview(critterView)
        critterView.snp.makeConstraints({ make in
            make.size.equalTo(critterViewDimension)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(critterViewTopMargin)
        })

        // 用户文本框布局
        view.addSubview(usernameTextField)
        usernameTextField.snp.makeConstraints({ make in
            make.width.equalTo(textFieldWidth)
            make.height.equalTo(textFieldHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(critterView.snp.bottom).offset(textFieldTopMargin)
        })

        // 密码文本框布局
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints({ make in
            make.width.equalTo(textFieldWidth)
            make.height.equalTo(textFieldHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(usernameTextField.snp.bottom).offset(textFieldSpacing)
        })
        
        // 登录按钮布局
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints({ make in
            make.width.equalTo(textFieldWidth - 20)
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(textFieldSpacing + 15)
        })
        
        stackView.addArrangedSubview(QQlogin)
        stackView.addArrangedSubview(WeChatlogin)
        
        QQlogin.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            var style = ToastManager.shared.style
            style.backgroundColor = UIColor.Material.green
            self.view.makeToast("QQ登录功能正在开发中", position: .top, style: style)
        }).disposed(by: rx.disposeBag)
        
        WeChatlogin.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            var style = ToastManager.shared.style
            style.backgroundColor = UIColor.Material.green
            self.view.makeToast("微信登录功能正在开发中", position: .top, style: style)
        }).disposed(by: rx.disposeBag)
        
        setUpGestures()
        setUpNotification()
        
        // 打开Flex的一个手指滑动手势
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleOneFingerSwipe(swipeRecognizer:)))
        swipeGesture.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    func bindViewModel() {
        // 🎃基础视图模型绑定
        viewModel?.loading.asDriver().drive(onNext: { [weak self] (isLoading) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
            isLoading ? self?.startAnimating() : self?.stopAnimating()
        }).disposed(by: rx.disposeBag)
        // 网络请求错误吐司提示
        viewModel?.requestError.subscribe(onNext: { [weak self] (error) in
            self?.view.makeToast(error.errMessage, image: R.image.icon_toast_warning())
        }).disposed(by: rx.disposeBag)
        // 抖动切换黑暗与明亮
        motionShakeEvent.subscribe(onNext: { () in
            nightModeEnabled.accept(!ThemeType.currentTheme().isDark)
        }).disposed(by: rx.disposeBag)
        
        // ☠️登录视图模型绑定
        guard let viewModel = viewModel as? LoginViewModel else { return }
        let loginTrigger = PublishSubject<Void>()
        loginButton.rx.tap.asDriver().drive(onNext: { [weak self] () in
            if self!.usernameTextField.text!.isBlank && self!.passwordTextField.text!.isBlank {
                return self!.view.makeToast("请输入用户名和密码", position: .bottom, image: R.image.icon_toast_warning())
            }
            
            guard !self!.usernameTextField.text!.isBlank else {
                return self!.view.makeToast("请输入用户名", position: .bottom, image: R.image.icon_toast_warning())
            }
            
            guard !self!.passwordTextField.text!.isBlank else {
                return self!.view.makeToast("请输入密码", position: .bottom, image: R.image.icon_toast_warning())
            }
            loginTrigger.onNext(())
        }).disposed(by: rx.disposeBag)
        let input = LoginViewModel.Input(loginTrigger: loginTrigger)
        let output = viewModel.transform(input: input)
        // 👀绑定登录数据
        _ = usernameTextField.rx.textInput <-> viewModel.username
        _ = passwordTextField.rx.textInput <-> viewModel.password
    }

    // 计算当前输入字符在文本框中的宽度
    private func fractionComplete(for textField: UITextField) -> Float {
        guard let text = textField.text, let font = textField.font else { return 0 }
        let textFieldWidth = textField.bounds.width - (2 * textFieldHorizontalMargin)
        return min(Float(text.size(withAttributes: [NSAttributedString.Key.font: font]).width / textFieldWidth), 1)
    }

    // 停止头部动画旋转
    private func stopHeadRotation() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        critterView.stopHeadRotation()
        passwordDidResignAsFirstResponder()
    }

    // 还原密码输入框
    private func passwordDidResignAsFirstResponder() {
        critterView.isPeeking = false
        critterView.isShy = false
        showHidePasswordButton.isHidden = true
        showHidePasswordButton.isSelected = false
        passwordTextField.isSecureTextEntry = true
    }

    // ⚽️ 创建文本框
    private func createTextField(text: String) -> UITextField {
        let view = UITextField(frame: CGRect(x: 0, y: 0, width: textFieldWidth, height: textFieldHeight))
        view.backgroundColor = .white
        view.theme.tintColor = themeService.attribute { $0.loginPrimaryDark }
        view.layer.cornerRadius = 4.07
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.spellCheckingType = .no
        view.delegate = self
        view.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let frame = CGRect(x: 0, y: 0, width: textFieldHorizontalMargin, height: textFieldHeight)
        view.leftView = UIView(frame: frame)
        view.leftViewMode = .always

        view.rightView = UIView(frame: frame)
        view.rightViewMode = .always

        view.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        view.textColor = LoginColorTheme.text

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: LoginColorTheme.disabledText ,
            .font: view.font!
        ]

        view.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)

        return view
    }

    // MARK: - Gestures
    private func setUpGestures() {
        view.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            self.stopHeadRotation()
        }).disposed(by: rx.disposeBag)
    }

    // 密码可见事件
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        let isPasswordVisible = sender.isSelected
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        critterView.isPeeking = isPasswordVisible

        // 🤡 将光标移动到字符的最后
        if let textRange = passwordTextField.textRange(from: passwordTextField.beginningOfDocument, to: passwordTextField.endOfDocument), let password = passwordTextField.text {
            passwordTextField.replace(textRange, withText: password)
        }
    }

    // MARK: - Notifications 🥶
    private func setUpNotification() {
        // 监听应用进入后台通知
        notificationCenter.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    // 应用进入后台通知事件
    @objc private func applicationDidEnterBackground() {
        stopHeadRotation()
    }

    // 抖动结束回调
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            motionShakeEvent.onNext(())
        }
    }
    
    // 请求开始动画
    func startAnimating() {
        SVProgressHUD.show()
    }
    
    // 请求结束动画
    func stopAnimating() {
        SVProgressHUD.dismiss()
    }
    
    // 打开UI调式工具
    @objc func handleOneFingerSwipe(swipeRecognizer: UISwipeGestureRecognizer) {
        if swipeRecognizer.state == .recognized {
            let libsManager: LibsManager = DIContainer.shared.resolve()
            libsManager.showFlex()
        }
    }
    
}
