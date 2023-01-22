//
//  设置国际化语言视图控制器
//  Created by 福尔摩翔 on 2022/11/29.
//  Copyright © 2022 entfrm All rights reserved.
//

import SwiftUI
import RxSwift
import RxCocoa
import RxDataSources

private let reuseIdentifier = R.reuseIdentifier.languageCell.identifier

class LanguageViewController: TableViewController {

    lazy var saveButtonItem: BarButtonItem = {
        let view = BarButtonItem(title: "", style: .plain, target: self, action: nil)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func makeUI() {
        super.makeUI()

        languageChanged.subscribe(onNext: { [weak self] () in
            self?.navigationTitle = R.string.localizable.languageNavigationTitle.key.localized()
            self?.saveButtonItem.title = R.string.localizable.commonSave.key.localized()
        }).disposed(by: rx.disposeBag)

        navigationItem.rightBarButtonItem = saveButtonItem
        tableView.register(R.nib.languageCell)
        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? LanguageViewModel else { return }

        let refresh = Observable.of(Observable.just(()), languageChanged.asObservable()).merge()
        let input = LanguageViewModel.Input(trigger: refresh,
                                          saveTrigger: saveButtonItem.rx.tap.asDriver(),
                                          selection: tableView.rx.modelSelected(LanguageCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

        output.items.drive(tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: LanguageCell.self)) { tableView, viewModel, cell in
            cell.bind(to: viewModel)
        }.disposed(by: rx.disposeBag)

        output.saved.drive(onNext: { [weak self] () in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }).disposed(by: rx.disposeBag)
    }
}
