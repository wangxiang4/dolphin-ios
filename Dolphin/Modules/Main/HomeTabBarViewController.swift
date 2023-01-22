//
//  首页标签栏目视图控制器
//  Created by 福尔摩翔 on 2022/11/27.
//  Copyright © 2022 entfrm All rights reserved.
//

import SwiftUI
import RAMAnimatedTabBarController
import Localize_Swift
import RxSwift
import RxCocoa
import WhatsNewKit

enum HomeTabBarItem: Int, CaseIterable {
    
    // 导航栏包含(首页,工作台,通知,设置)
    case home, workbench, notifications, settings

    private func controller(with viewModel: ViewModel) -> UIViewController {
        switch self {
        case .home:
            let vc = HomeViewController(viewModel: viewModel)
            return NavigationController(rootViewController: vc)
        case .workbench:
            let vc = WorkbenchViewController(viewModel: viewModel)
            return NavigationController(rootViewController: vc)
        case .notifications:
            let vc = NotificationsViewController(viewModel: viewModel)
            return NavigationController(rootViewController: vc)
        case .settings:
            let vc = SettingsViewController(viewModel: viewModel)
            return NavigationController(rootViewController: vc)
        }
    }

    // 标签栏图片
    var image: UIImage? {
        switch self {
        case .home: return R.image.icon_tabbar_home()
        case .workbench: return R.image.icon_tabbar_workbench()
        case .notifications: return R.image.icon_tabbar_activity()
        case .settings: return R.image.icon_tabbar_settings()
        }
    }

    // 标签栏标题
    var title: String {
        switch self {
        case .home: return R.string.localizable.homeTabBarHomeTitle.key.localized()
        case .workbench: return R.string.localizable.homeTabBarWorkbenchTitle.key.localized()
        case .notifications: return R.string.localizable.homeTabBarNotificationsTitle.key.localized()
        case .settings: return R.string.localizable.homeTabBarSettingsTitle.key.localized()
        }
    }

    var animation: RAMItemAnimation {
        var animation: RAMItemAnimation
        switch self {
        case .home: animation = RAMBounceAnimation()
        case .workbench: animation = RAMBounceAnimation()
        case .notifications: animation = RAMBounceAnimation()
        case .settings: animation = RAMRightRotationAnimation()
        }
        animation.theme.iconSelectedColor = themeService.attribute { $0.secondary }
        animation.theme.textSelectedColor = themeService.attribute { $0.secondary }
        return animation
    }

    func getController(with viewModel: ViewModel) -> UIViewController {
        let vc = controller(with: viewModel)
        let item = RAMAnimatedTabBarItem(title: title, image: image, tag: rawValue)
        item.animation = animation
        item.theme.iconColor = themeService.attribute { $0.text }
        item.theme.textColor = themeService.attribute { $0.text }
        vc.tabBarItem = item
        return vc
    }
}

class HomeTabBarViewController: RAMAnimatedTabBarController {

    var viewModel: HomeTabBarViewModel?

    init(viewModel: ViewModel?) {
        self.viewModel = viewModel as? HomeTabBarViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        // 不实现自定义故事版标识符指定,用内部默认代码绘制的标签场景界面
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bindViewModel()
    }

    func makeUI() {
        NotificationCenter.default
            .rx.notification(NSNotification.Name(LCLLanguageChangeNotification))
            .subscribe { [weak self] (event) in
                self?.animatedItems.forEach({ (item) in
                    item.title = HomeTabBarItem(rawValue: item.tag)?.title
                })
                self?.setViewControllers(self?.viewControllers, animated: false)
                self?.setSelectIndex(from: 0, to: self?.selectedIndex ?? 0)
            }.disposed(by: rx.disposeBag)

        tabBar.theme.barTintColor = themeService.attribute { $0.primaryDark }

        themeService.typeStream.delay(DispatchTimeInterval.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe(onNext: { (theme) in
                switch theme {
                case .light(let color), .dark(let color):
                    self.changeSelectedColor(color.color, iconSelectedColor: color.color)
                }
            }).disposed(by: rx.disposeBag)
    }

    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        let input = HomeTabBarViewModel.Input(whatsNewTrigger: rx.viewDidAppear.mapToVoid())
        let output = viewModel.transform(input: input)
        output.openWhatsNew.drive(onNext: { [weak self] (block) in
            let controllers = HomeTabBarItem.allCases.map {
                $0.getController(with: viewModel.viewModel(for: $0))
            }
            // 设置首页标签栏目
            self?.setViewControllers(controllers, animated: true)
            
            let vc: UIViewController?
            if let versionStore = block.2 {
                vc = WhatsNewViewController(whatsNew: block.0, configuration: block.1, versionStore: versionStore)
            } else {
                vc = WhatsNewViewController(whatsNew: block.0, configuration: block.1)
            }
            DispatchQueue.main.async {
                if let target = vc {
                    let nav = NavigationController(rootViewController: target)
                    self!.present(nav, animated: true, completion: nil)
                }
            }
        }).disposed(by: rx.disposeBag)
    }
    
}
