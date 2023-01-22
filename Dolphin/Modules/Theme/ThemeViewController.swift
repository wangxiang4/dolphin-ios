//
//  设置国际化语言视图控制器
//  Created by 福尔摩翔 on 2022/11/29.
//  Copyright © 2022 entfrm All rights reserved.
//

import SwiftUI
import RxSwift
import RxCocoa

private let reuseIdentifier = R.reuseIdentifier.themeCell.identifier

class ThemeViewController: TableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func makeUI() {
        super.makeUI()
        languageChanged.subscribe(onNext: { [weak self] () in
            self?.navigationTitle =  R.string.localizable.themeNavigationTitle.key.localized()
        }).disposed(by: rx.disposeBag)
        tableView.register(R.nib.themeCell)
        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? ThemeViewModel else { return }

        let input = ThemeViewModel.Input(refresh: Observable.just(()),
                                         selection: tableView.rx.modelSelected(ThemeCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

        output.items.drive(tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: ThemeCell.self)) { tableView, viewModel, cell in
            cell.bind(to: viewModel)
        }.disposed(by: rx.disposeBag)

        output.selected.drive(onNext: { [weak self] (cellViewModel) in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }).disposed(by: rx.disposeBag)
    }
}
