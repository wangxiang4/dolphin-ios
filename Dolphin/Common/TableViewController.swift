//
//  表格视图控制器数据绑定,初始化默认配置
//  Created by wangxiang4 on 2022/11/27.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import SwiftUI
import RxSwift
import RxCocoa
import KafkaRefresh
import Toast_Swift

class TableViewController: ViewController, UIScrollViewDelegate {

    // 下拉刷新触发器
    let headerRefreshTrigger = PublishSubject<Void>()
    let footerRefreshTrigger = PublishSubject<Void>()

    // 显示下拉加载
    let isHeaderLoading = BehaviorRelay(value: false)
    let isFooterLoading = BehaviorRelay(value: false)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deselectSelectedRow()
    }

    // 创建表格视图
    lazy var tableView: TableView = {
        let view = TableView(frame: CGRect(), style: .plain)
        view.emptyDataSetSource = self
        view.emptyDataSetDelegate = self
        view.rx.setDelegate(self).disposed(by: rx.disposeBag)
        return view
    }()

    // 渲染ui与数据绑定
    override func makeUI() {
        super.makeUI()

        stackView.spacing = 0
        stackView.insertArrangedSubview(tableView, at: 0)
        
        // 绑定头部刷新触发器
        tableView.bindGlobalStyle(forHeadRefreshHandler: { [weak self] in
            self?.headerRefreshTrigger.onNext(())
        })
        // 绑定尾部刷新触发器
        tableView.bindGlobalStyle(forFootRefreshHandler: { [weak self] in
            self?.footerRefreshTrigger.onNext(())
        })
        isHeaderLoading.bind(to: tableView.headRefreshControl.rx.isAnimating).disposed(by: rx.disposeBag)
        isFooterLoading.bind(to: tableView.footRefreshControl.rx.isAnimating).disposed(by: rx.disposeBag)
    }

    override func bindViewModel() {
        super.bindViewModel()
        viewModel?.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: rx.disposeBag)
        viewModel?.footerLoading.asObservable().bind(to: isFooterLoading).disposed(by: rx.disposeBag)
        // 更新表格空数据集
        let updateEmptyDataSet = Observable.of(isLoading.mapToVoid().asObservable(), languageChanged.asObservable()).merge()
        updateEmptyDataSet.subscribe(onNext: { [weak self] () in
            self?.tableView.reloadEmptyDataSet()
        }).disposed(by: rx.disposeBag)
    }
}

extension TableViewController {
    // 取消选中行
    func deselectSelectedRow() {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
            selectedIndexPaths.forEach({ (indexPath) in
                tableView.deselectRow(at: indexPath, animated: false)
            })
        }
    }
}

extension TableViewController: UITableViewDelegate {
    // 设置表格分类页头标题颜色
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView, let textLabel = view.textLabel {
            textLabel.font = UIFont.systemFont(ofSize: 15)
            textLabel.theme.textColor = themeService.attribute { $0.text }
            view.contentView.theme.backgroundColor = themeService.attribute { $0.primaryDark }
        }
    }
}
