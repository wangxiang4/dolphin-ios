//
//  设置视图控制器
//  Created by wangxiang4 on 2022/11/29.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import SwiftUI
import RxSwift
import RxCocoa
import RxDataSources
import WhatsNewKit
import Toast_Swift

private let switchReuseIdentifier = R.reuseIdentifier.userSwitchCell.identifier
private let reuseIdentifier = R.reuseIdentifier.userCell.identifier
class UserViewController: TableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    // 懒加载顶部头视图
    private lazy var headerView: UserHeaderView = {
        let view = UserHeaderView()
        view.delegate = self
        return view
    }()
    
    override func makeUI() {
        super.makeUI()
        languageChanged.subscribe(onNext: { [weak self] () in
            self?.navigationTitle = R.string.localizable.homeTabBarUserTitle.key.localized()
        }).disposed(by: rx.disposeBag)
        stackView.insertArrangedSubview(headerView, at: 0)
        tableView.register(R.nib.userCell)
        tableView.register(R.nib.userSwitchCell)
        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? UserViewModel else { return }
        let refresh = Observable.of(rx.viewWillAppear.mapToVoid(), languageChanged.asObservable()).merge()
        let input = UserViewModel.Input(trigger: refresh, selection: tableView.rx.modelSelected(UserSectionItem.self).asDriver())
        let output = viewModel.transform(input: input)
        
        let dataSource = RxTableViewSectionedReloadDataSource<UserSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .nightModeItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: switchReuseIdentifier, for: indexPath) as? UserSwitchCell)!
                cell.bind(to: viewModel)
                return cell
            case .themeItem(let viewModel),
                 .languageItem(let viewModel),
                 .removeCacheItem(let viewModel),
                 .whatsNewItem(let viewModel),
                 .logoutItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? UserCell)!
                cell.bind(to: viewModel)
                return cell
            }
        })

        output.items.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        output.selectedEvent.drive(onNext: { [weak self] (item) in
            switch item {
            case .nightModeItem:
                self?.deselectSelectedRow()
            case .themeItem:
                if let viewModel = viewModel.viewModel(for: item) as? ThemeViewModel {
                    DispatchQueue.main.async {
                        let themeVC: ThemeViewController = ThemeViewController(viewModel: ThemeViewModel())
                        let nav = NavigationController(rootViewController: themeVC)
                        self?.showDetailViewController(nav, sender: nil)
                    }
                }
            case .languageItem:
                if let viewModel = viewModel.viewModel(for: item) as? LanguageViewModel {
                    DispatchQueue.main.async {
                        let languageVC: LanguageViewController = LanguageViewController(viewModel: LanguageViewModel())
                        let nav = NavigationController(rootViewController: languageVC)
                        self?.showDetailViewController(nav, sender: nil)
                    }
                }
            case .removeCacheItem:
                self?.deselectSelectedRow()
            case .whatsNewItem:
                DispatchQueue.main.async {
                    let vc: UIViewController!
                    let block: WhatsNewBlock = viewModel.whatsNewBlock()
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
                }
            case .logoutItem:
                self?.deselectSelectedRow()
                self?.logoutAction()
            }
        }).disposed(by: rx.disposeBag)
    }
    
    func logoutAction() {
        let alertController = UIAlertController(title: "温馨提示", message: R.string.localizable.userLogoutAlertMessage.key.localized(), preferredStyle: UIAlertController.Style.alert)
      
        let logoutAction = UIAlertAction(title: R.string.localizable.userLogoutAlertConfirmButtonTitle.key.localized(), style: .destructive) { [weak self] (result: UIAlertAction) in
            PermissionUtil.logout()
        }

        let cancelAction = UIAlertAction(title: R.string.localizable.commonCancel.key.localized(), style: .default) { (result: UIAlertAction) in
        }
        alertController.addAction(cancelAction)
        alertController.addAction(logoutAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

extension UserViewController: UserHeaderViewDelegate {
    
    // 图片点击
    func imgViewClick(imgView: UIImageView) {
        var style = ToastManager.shared.style
        style.backgroundColor = UIColor.Material.green
        self.view.makeToast("图片点击功能正在开发中", position: .bottom, style: style)
    }
    
}
