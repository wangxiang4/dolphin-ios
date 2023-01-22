//
//  应用主题管理
//  采用RxTheme全局ui组件监听切换
//  Created by wangxiang4 on 2022/12/5.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxTheme
import RAMAnimatedTabBarController
import KafkaRefresh

// 状态栏样式
let globalStatusBarStyle = BehaviorRelay<UIStatusBarStyle>(value: .default)

// RX主题服务
let themeService = ThemeType.service(initial: ThemeType.currentTheme())

// 主题配置协议
protocol Theme {
    var primary: UIColor { get }
    var primaryDark: UIColor { get }
    var secondary: UIColor { get }
    var secondaryDark: UIColor { get }
    var separator: UIColor { get }
    var text: UIColor { get }
    var textGray: UIColor { get }
    var background: UIColor { get }
    var statusBarStyle: UIStatusBarStyle { get }
    var barStyle: UIBarStyle { get }
    var keyboardAppearance: UIKeyboardAppearance { get }
    var blurStyle: UIBlurEffect.Style { get }
    var loginPrimaryDark: UIColor { get }
    var loginPrimaryLight: UIColor { get }
    init(colorTheme: ColorTheme)
}

// 明亮主题
struct LightTheme: Theme {
    let primary = UIColor.Material.white
    let primaryDark = UIColor.Material.grey200
    var secondary = UIColor.Material.red
    var secondaryDark = UIColor.Material.red900
    let separator = UIColor.Material.grey50
    let text = UIColor.Material.grey900
    let textGray = UIColor.Material.grey
    let background = UIColor.Material.white
    let statusBarStyle = UIStatusBarStyle.default
    let barStyle = UIBarStyle.default
    let keyboardAppearance = UIKeyboardAppearance.light
    let blurStyle = UIBlurEffect.Style.extraLight
    let loginPrimaryDark = #colorLiteral(red: 0.768627451, green: 1, blue: 0.9764705882, alpha: 1)
    let loginPrimaryLight = #colorLiteral(red: 0.02745098039, green: 0.7450980392, blue: 0.7215686275, alpha: 1)
    
    init(colorTheme: ColorTheme) {
        secondary = colorTheme.color
        secondaryDark = colorTheme.colorDark
    }
}

// 黑暗主题
struct DarkTheme: Theme {
    let primary = UIColor.Material.grey800
    let primaryDark = UIColor.Material.grey900
    var secondary = UIColor.Material.red
    var secondaryDark = UIColor.Material.red900
    let separator = UIColor.Material.grey900
    let text = UIColor.Material.grey50
    let textGray = UIColor.Material.grey
    let background = UIColor.Material.grey800
    let statusBarStyle = UIStatusBarStyle.lightContent
    let barStyle = UIBarStyle.black
    let keyboardAppearance = UIKeyboardAppearance.dark
    let blurStyle = UIBlurEffect.Style.dark
    let loginPrimaryDark = #colorLiteral(red: 0.02745098039, green: 0.7450980392, blue: 0.7215686275, alpha: 1)
    let loginPrimaryLight = #colorLiteral(red: 0.768627451, green: 1, blue: 0.9764705882, alpha: 1)
    
    init(colorTheme: ColorTheme) {
        secondary = colorTheme.color
        secondaryDark = colorTheme.colorDark
    }
}

// 颜色主题
enum ColorTheme: Int {
    case red, pink, purple, deepPurple, indigo, blue, lightBlue, cyan, teal, green, lightGreen, lime, yellow, amber, orange, deepOrange, brown, gray, blueGray
    static let allValues = [red, pink, purple, deepPurple, indigo, blue, lightBlue, cyan, teal, green, lightGreen, lime, yellow, amber, orange, deepOrange, brown, gray, blueGray]

    // 浅颜色
    var color: UIColor {
        switch self {
        case .red: return UIColor.Material.red
        case .pink: return UIColor.Material.pink
        case .purple: return UIColor.Material.purple
        case .deepPurple: return UIColor.Material.deepPurple
        case .indigo: return UIColor.Material.indigo
        case .blue: return UIColor.Material.blue
        case .lightBlue: return UIColor.Material.lightBlue
        case .cyan: return UIColor.Material.cyan
        case .teal: return UIColor.Material.teal
        case .green: return UIColor.Material.green
        case .lightGreen: return UIColor.Material.lightGreen
        case .lime: return UIColor.Material.lime
        case .yellow: return UIColor.Material.yellow
        case .amber: return UIColor.Material.amber
        case .orange: return UIColor.Material.orange
        case .deepOrange: return UIColor.Material.deepOrange
        case .brown: return UIColor.Material.brown
        case .gray: return UIColor.Material.grey
        case .blueGray: return UIColor.Material.blueGrey
        }
    }
    
    // 深颜色
    var colorDark: UIColor {
        switch self {
        case .red: return UIColor.Material.red900
        case .pink: return UIColor.Material.pink900
        case .purple: return UIColor.Material.purple900
        case .deepPurple: return UIColor.Material.deepPurple900
        case .indigo: return UIColor.Material.indigo900
        case .blue: return UIColor.Material.blue900
        case .lightBlue: return UIColor.Material.lightBlue900
        case .cyan: return UIColor.Material.cyan900
        case .teal: return UIColor.Material.teal900
        case .green: return UIColor.Material.green900
        case .lightGreen: return UIColor.Material.lightGreen900
        case .lime: return UIColor.Material.lime900
        case .yellow: return UIColor.Material.yellow900
        case .amber: return UIColor.Material.amber900
        case .orange: return UIColor.Material.orange900
        case .deepOrange: return UIColor.Material.deepOrange900
        case .brown: return UIColor.Material.brown900
        case .gray: return UIColor.Material.grey900
        case .blueGray: return UIColor.Material.blueGrey900
        }
    }

    // 颜色标题
    var title: String {
        switch self {
        case .red: return "红色"
        case .pink: return "粉色"
        case .purple: return "紫色"
        case .deepPurple: return "深紫色"
        case .indigo: return "紫蓝色"
        case .blue: return "蓝色"
        case .lightBlue: return "浅蓝色"
        case .cyan: return "青色"
        case .teal: return "蓝绿色"
        case .green: return "绿色"
        case .lightGreen: return "浅绿色"
        case .lime: return "石灰色"
        case .yellow: return "黄色"
        case .amber: return "琥珀色"
        case .orange: return "橙色"
        case .deepOrange: return "深橙色"
        case .brown: return "棕色"
        case .gray: return "灰色"
        case .blueGray: return "蓝灰色"
        }
    }
}

// 主题提供扩展
enum ThemeType: ThemeProvider {
    case light(color: ColorTheme)
    case dark(color: ColorTheme)

    // 关联ui组件的颜色
    var associatedObject: Theme {
        switch self {
        case .light(let color): return LightTheme(colorTheme: color)
        case .dark(let color): return DarkTheme(colorTheme: color)
        }
    }

    // 检测是否黑暗主题
    var isDark: Bool {
        switch self {
        case .dark: return true
        default: return false
        }
    }

    // 切换主题时保存数据
    func toggled() -> ThemeType {
        var theme: ThemeType
        switch self {
        case .light(let color): theme = ThemeType.dark(color: color)
        case .dark(let color): theme = ThemeType.light(color: color)
        }
        theme.save()
        return theme
    }

    // 设置主题颜色保存数据
    func withColor(color: ColorTheme) -> ThemeType {
        var theme: ThemeType
        switch self {
        case .light: theme = ThemeType.light(color: color)
        case .dark: theme = ThemeType.dark(color: color)
        }
        theme.save()
        return theme
    }
}

extension ThemeType {
    
    // 获取当前主题数据
    static func currentTheme() -> ThemeType {
        let defaults = UserDefaults.standard
        let isDark = defaults.bool(forKey: "IsDarkKey")
        let colorTheme = ColorTheme(rawValue: defaults.integer(forKey: "ThemeKey")) ?? ColorTheme.red
        let theme = isDark ? ThemeType.dark(color: colorTheme) : ThemeType.light(color: colorTheme)
        theme.save()
        return theme
    }

    // 保存当前主题数据
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(self.isDark, forKey: "IsDarkKey")
        switch self {
        case .light(let color): defaults.set(color.rawValue, forKey: "ThemeKey")
        case .dark(let color): defaults.set(color.rawValue, forKey: "ThemeKey")
        }
    }
    
}

// 扩展切换UIView背景颜色
extension Reactive where Base: UIView {
    var backgroundColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.backgroundColor = attr
        }
    }
}

// 扩展切换UIButton背景颜色
extension Reactive where Base: UIButton {
    func backgroundImage(for state: UIControl.State) -> Binder<UIColor> {
        return Binder(self.base) { view, attr in
            let image = UIImage(color: attr, size: CGSize(width: 1, height: 1))
            view.setBackgroundImage(image, for: state)
        }
    }
}

// 扩展切换UITextField颜色
extension Reactive where Base: UITextField {
    var borderColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.borderColor = attr
        }
    }

    var placeholderColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            if let color = attr {
                view.setPlaceHolderTextColor(color)
            }
        }
    }
}

// 扩展切换UITableView换行线颜色
extension Reactive where Base: UITableView {
    var separatorColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.separatorColor = attr
        }
    }
}

// 扩展切换TableViewCell列选择颜色
extension Reactive where Base: TableViewCell {
    var selectionColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.selectionColor = attr
        }
    }
}

// 扩展切换标签栏图标颜色
extension Reactive where Base: RAMAnimatedTabBarItem {
    var iconColor: Binder<UIColor> {
        return Binder(self.base) { view, attr in
            view.iconColor = attr
            view.deselectAnimation()
        }
    }

    var textColor: Binder<UIColor> {
        return Binder(self.base) { view, attr in
            view.textColor = attr
            view.deselectAnimation()
        }
    }
}

// 扩展切换标签栏图标选中颜色
extension Reactive where Base: RAMItemAnimation {
    var iconSelectedColor: Binder<UIColor> {
        return Binder(self.base) { view, attr in
            view.iconSelectedColor = attr
        }
    }

    var textSelectedColor: Binder<UIColor> {
        return Binder(self.base) { view, attr in
            view.textSelectedColor = attr
        }
    }
}

// 扩展切换导航栏文本颜色
extension Reactive where Base: UINavigationBar {
    var largeTitleTextAttributes: Binder<[NSAttributedString.Key: Any]?> {
        return Binder(self.base) { view, attr in
            view.largeTitleTextAttributes = attr
        }
    }
}

// 扩展设置当前状态栏颜色
extension Reactive where Base: UIApplication {
    var statusBarStyle: Binder<UIStatusBarStyle> {
        return Binder(self.base) { view, attr in
            globalStatusBarStyle.accept(attr)
        }
    }
}

// 扩展切换下拉刷新颜色
extension Reactive where Base: KafkaRefreshDefaults {
    var themeColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.themeColor = attr
        }
    }
}

// 扩展切换UISwitch颜色
public extension Reactive where Base: UISwitch {
    var onTintColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.onTintColor = attr
        }
    }

    var thumbTintColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.thumbTintColor = attr
        }
    }
}

// 扩展UIApplication组件主题代理
extension ThemeProxy where Base: UIApplication {
    var statusBarStyle: ThemeAttribute<UIStatusBarStyle> {
        get { fatalError("set only") }
        set {
            let disposable = newValue.stream
                .take(until: base.rx.deallocating)
                .observe(on: MainScheduler.instance)
                .bind(to: base.rx.statusBarStyle)
            hold(disposable, for: "statusBarStyle")
        }
    }
}

// 扩展UIButton组件主题代理
extension ThemeProxy where Base: UIButton {
    func backgroundImage(from newValue: ThemeAttribute<UIColor>, for state: UIControl.State) {
        let disposable = newValue.stream
            .take(until: base.rx.deallocating)
            .observe(on: MainScheduler.instance)
            .bind(to: base.rx.backgroundImage(for: state))
        hold(disposable, for: "backgroundImage.forState.\(state.rawValue)")
    }
}

// 扩展UITextField组件主题代理
extension ThemeProxy where Base: UITextField {
    var borderColor: ThemeAttribute<UIColor?> {
        get { fatalError("set only") }
        set {
            let disposable = newValue.stream
                .take(until: base.rx.deallocating)
                .observe(on: MainScheduler.instance)
                .bind(to: base.rx.borderColor)
            hold(disposable, for: "borderColor")
        }
    }

    var placeholderColor: ThemeAttribute<UIColor?> {
        get { fatalError("set only") }
        set {
            let disposable = newValue.stream
                .take(until: base.rx.deallocating)
                .observe(on: MainScheduler.instance)
                .bind(to: base.rx.placeholderColor)
            hold(disposable, for: "placeholderColor")
        }
    }
}

// 扩展TableViewCell组件主题代理
extension ThemeProxy where Base: TableViewCell {
    var selectionColor: ThemeAttribute<UIColor?> {
        get { fatalError("set only") }
        set {
            let disposable = newValue.stream
                .take(until: base.rx.deallocating)
                .observe(on: MainScheduler.instance)
                .bind(to: base.rx.selectionColor)
            hold(disposable, for: "selectionColor")
        }
    }
}

// 扩展RAMAnimatedTabBarItem组件主题代理
extension ThemeProxy where Base: RAMAnimatedTabBarItem {
    var iconColor: ThemeAttribute<UIColor> {
        get { fatalError("set only") }
        set {
            let disposable = newValue.stream
                .take(until: base.rx.deallocating)
                .observe(on: MainScheduler.instance)
                .bind(to: base.rx.iconColor)
            hold(disposable, for: "iconColor")
        }
    }

    var textColor: ThemeAttribute<UIColor> {
        get { fatalError("set only") }
        set {
            let disposable = newValue.stream
                .take(until: base.rx.deallocating)
                .observe(on: MainScheduler.instance)
                .bind(to: base.rx.textColor)
            hold(disposable, for: "textColor")
        }
    }
}

// 扩展RAMItemAnimation组件主题代理
extension ThemeProxy where Base: RAMItemAnimation {
    var iconSelectedColor: ThemeAttribute<UIColor> {
        get { fatalError("set only") }
        set {
            let disposable = newValue.stream
                .take(until: base.rx.deallocating)
                .observe(on: MainScheduler.instance)
                .bind(to: base.rx.iconSelectedColor)
            hold(disposable, for: "iconSelectedColor")
        }
    }

    var textSelectedColor: ThemeAttribute<UIColor> {
        get { fatalError("set only") }
        set {
            let disposable = newValue.stream
                .take(until: base.rx.deallocating)
                .observe(on: MainScheduler.instance)
                .bind(to: base.rx.textSelectedColor)
            hold(disposable, for: "textSelectedColor")
        }
    }
}

// 扩展KafkaRefreshDefaults组件主题代理
extension ThemeProxy where Base: KafkaRefreshDefaults {
    var themeColor: ThemeAttribute<UIColor?> {
        get { fatalError("set only") }
        set {
            let disposable = newValue.stream
                .take(until: base.rx.deallocating)
                .observe(on: MainScheduler.instance)
                .bind(to: base.rx.themeColor)
            hold(disposable, for: "themeColor")
        }
    }
}
