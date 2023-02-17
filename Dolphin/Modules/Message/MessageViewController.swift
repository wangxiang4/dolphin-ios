//
//  通知视图控制器
//  Created by wangxiang4 on 2022/11/29.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import SwiftUI
import RxSwift
import RxCocoa
import RxDataSources
import Toast_Swift

private let reuseIdentifier = R.reuseIdentifier.messageCell.identifier

class MessageViewController: TableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func makeUI() {
        super.makeUI()
        languageChanged.subscribe(onNext: { [weak self] () in
            self?.navigationTitle = R.string.localizable.homeTabBarMessageTitle.key.localized()
        }).disposed(by: rx.disposeBag)
        tableView.register(R.nib.messageCell)
    }

    override func bindViewModel() {
        super.bindViewModel()
        // 网络请求错误吐司提示
        viewModel?.requestError.subscribe(onNext: { [weak self] (error) in
            self?.view.makeToast(error.errMessage, image: R.image.icon_toast_warning())
        }).disposed(by: rx.disposeBag)
        guard let viewModel = viewModel as? MessageViewModel else { return }
        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger).merge()
        let input = MessageViewModel.Input(headerRefresh: refresh, footerRefresh: footerRefreshTrigger)
        let output = viewModel.transform(input: input)
        
        output.items.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: MessageCell.self)) { tableView, viewModel, cell in
                cell.bind(to: viewModel)
            }.disposed(by: rx.disposeBag)
        
        output.rowSelected.drive(onNext: { [weak self] item in
            logDebug("\(item.toJSON())")
            var style = ToastManager.shared.style
            style.backgroundColor = UIColor.Material.green
            self?.view.makeToast("当前行数据为:\(item.toJSON())", position: .top, style: style)
        }).disposed(by: rx.disposeBag)
    }
}
