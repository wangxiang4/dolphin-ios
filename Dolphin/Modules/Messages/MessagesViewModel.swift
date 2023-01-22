//
//  消息通知视图模型
//  Created by wangxiang4 on 2022/11/29.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class MessagesViewModel: ViewModel, ViewModelType {

    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
    }

    struct Output {
        let items: BehaviorRelay<[MessageCellViewModel]>
        let rowSelected: Driver<OSSFile>
    }

    let httpRequest: HttpRequest = DIContainer.shared.resolve()
    
    // 点击行操作
    let rowSelected = PublishSubject<OSSFile>()
    
    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[MessageCellViewModel]>(value: [])
        
        // 处理头部刷新
        input.headerRefresh.flatMapLatest({ [weak self] in
            guard let self = self else { return Observable.just(BaseResultResponseArray<OSSFile>()) }
            self.PageCurrent = 1
            return self.httpRequest
                .listFile(current: self.PageCurrent, size: self.PageSize)
                .trackActivity(self.loading)
                .trackActivity(self.headerLoading)
                .map { $0 }
        }).subscribe(onNext: { result in
            if result.code == result.SUCCESS, let data = result.data {
                let items = data.map({ item -> MessageCellViewModel in
                    let viewModel = MessageCellViewModel(with: item)
                    viewModel.rowSelected.bind(to: self.rowSelected).disposed(by: self.rx.disposeBag)
                    return viewModel
                })
                elements.accept(items)
            } else {
                self.requestError.onNext(ApiError(result.code, result.msg))
            }
        }, onError: { error in self.bindConverRequestError.onNext(error) }).disposed(by: rx.disposeBag)
        
        // 处理尾部刷新
        input.footerRefresh.flatMapLatest({ [weak self] in
            guard let self = self else { return Observable.just(BaseResultResponseArray<OSSFile>()) }
            return self.httpRequest
                .listFile(current: self.PageCurrent + 1, size: self.PageSize)
                .trackActivity(self.loading)
                .trackActivity(self.footerLoading)
                .map { $0 }
        }).subscribe(onNext: { result in
            if result.code == result.SUCCESS, let data = result.data {
                let items = data.map({ item -> MessageCellViewModel in
                    let viewModel = MessageCellViewModel(with: item)
                    viewModel.rowSelected.bind(to: self.rowSelected).disposed(by: self.rx.disposeBag)
                    return viewModel
                })
                guard !ArrayUtil.isEmpty(data) else { return }
                elements.accept(elements.value + items)
                self.PageCurrent += 1
            } else {
                self.requestError.onNext(ApiError(result.code, result.msg))
            }
        }, onError: { error in self.bindConverRequestError.onNext(error) }).disposed(by: rx.disposeBag)

       return Output(items: elements, rowSelected: rowSelected.asDriver(onErrorJustReturn: OSSFile()))
    }
}
