//
//  设置视图模型
//  Created by wangxiang4 on 2022/11/29.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class UserViewModel: ViewModel, ViewModelType {

    struct Input {
        let trigger: Observable<Void>
        let selection: Driver<UserSectionItem>
    }

    struct Output {
        let items: BehaviorRelay<[UserSection]>
        let selectedEvent: Driver<UserSectionItem>
    }

    override init() {
        whatsNewManager = DIContainer.shared.resolve()
        super.init()
    }
    
    let whatsNewManager: WhatsNewManager
    
    // 不能使用 rx.disposeBag 重用列,rx销毁冲突
    var cellDisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {

        let elements = BehaviorRelay<[UserSection]>(value: [])
        let removeCache = PublishSubject<Void>()
        let libsManager: LibsManager = DIContainer.shared.resolve()
        
        let cacheRemoved = removeCache.flatMapLatest { () -> Observable<Void> in
            return libsManager.removeKingfisherCache()
        }
        
        let refresh = Observable.of(input.trigger, cacheRemoved, nightModeEnabled.mapToVoid()).merge()
        
        let cacheSize = refresh.flatMapLatest { () -> Observable<Int> in
            return libsManager.kingfisherCacheSize()
        }
        
        Observable.combineLatest(refresh, cacheSize).map { [weak self] (_, size) -> [UserSection] in
            guard let self = self else { return [] }
            var items: [UserSection] = []
            
            let nightModeCellViewModel = UserSwitchCellViewModel(with: R.string.localizable.userNightModeTitle.key.localized(), detail: nil, image: R.image.icon_cell_night_mode()?.template, hidesDisclosure: true, isEnabled: nightModeEnabled.value)
            nightModeCellViewModel.switchChanged.skip(1).bind(to: nightModeEnabled).disposed(by: self.cellDisposeBag)

            let themeCellViewModel = UserCellViewModel(with: R.string.localizable.userThemeTitle.key.localized(), detail: nil, image: R.image.icon_cell_theme()?.template, hidesDisclosure: false)

            let languageCellViewModel = UserCellViewModel(with: R.string.localizable.userLanguageTitle.key.localized(), detail: nil, image: R.image.icon_cell_language()?.template, hidesDisclosure: false)

            let removeCacheCellViewModel = UserCellViewModel(with: R.string.localizable.userRemoveCacheTitle.key.localized(), detail: size.sizeFromByte(), image: R.image.icon_cell_remove()?.template, hidesDisclosure: true)
        
            let whatsNewCellViewModel = UserCellViewModel(with: R.string.localizable.userWhatsNewTitle.key.localized(), detail: nil, image: R.image.icon_cell_whats_new()?.template, hidesDisclosure: false)
            
            let logoutCellViewModel = UserCellViewModel(with: R.string.localizable.userLogOutTitle.key.localized(), detail: nil, image: R.image.icon_cell_logout()?.template, hidesDisclosure: false)

            items += [
                UserSection.setting(title: "", items: [
                    UserSectionItem.nightModeItem(viewModel: nightModeCellViewModel),
                    UserSectionItem.themeItem(viewModel: themeCellViewModel),
                    UserSectionItem.languageItem(viewModel: languageCellViewModel),
                    UserSectionItem.removeCacheItem(viewModel: removeCacheCellViewModel),
                    UserSectionItem.whatsNewItem(viewModel: whatsNewCellViewModel),
                    UserSectionItem.logoutItem(viewModel: logoutCellViewModel)
                ])
            ]

            return items
        }.bind(to: elements).disposed(by: rx.disposeBag)
                
        let selectedEvent = input.selection
        selectedEvent.asObservable().subscribe(onNext: { (item) in
            switch item {
            case .removeCacheItem: removeCache.onNext(())
            default: break
            }
        }).disposed(by: rx.disposeBag)

        return Output(items: elements, selectedEvent: selectedEvent)
    }

    func viewModel(for item: UserSectionItem) -> ViewModel? {
        switch item {
        case .themeItem:
            let viewModel = ThemeViewModel()
            return viewModel
        case .languageItem:
            let viewModel = LanguageViewModel()
            return viewModel
        default:
            return nil
        }
    }

    func whatsNewBlock() -> WhatsNewBlock {
        return whatsNewManager.whatsNew(trackVersion: false)
    }
}
