//
//  主页视图模型
//  Created by wangxiang4 on 2022/11/29.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class HomeViewModel: ViewModel, ViewModelType {

    struct Input {
        let selection: Driver<HomeSectionItem>
    }

    struct Output {
        let items: BehaviorRelay<[HomeSection]>
        let selectedEvent: Driver<HomeSectionItem>
    }

    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[HomeSection]>(value: [])
        var items: [HomeSection] = []
        
        let notificationCellViewModel = HomeCellViewModel(with: "消息通知", detail: nil, image: R.image.icon_tabbar_activity()?.template, hidesDisclosure: false)
        let flashCellViewModel = HomeCellViewModel(with: "闪光灯通知", detail: nil, image: R.image.icon_cell_updated()?.template, hidesDisclosure: false)
        let vibrationCellViewModel = HomeCellViewModel(with: "震动反馈", detail: nil, image: R.image.icon_cell_size()?.template, hidesDisclosure: false)
        let voiceCellViewModel = HomeCellViewModel(with: "语音播报", detail: nil, image: R.image.icon_cell_night_mode()?.template, hidesDisclosure: false)
        let settingsCellViewModel = HomeCellViewModel(with: "跳转软件设置", detail: nil, image: R.image.icon_tabbar_settings()?.template, hidesDisclosure: false)
        let cameraCellViewModel = HomeCellViewModel(with: "打开照相机", detail: nil, image: R.image.icon_cell_profile_summary()?.template, hidesDisclosure: false)
        let albumCellViewModel = HomeCellViewModel(with: "打开相册", detail: nil, image: R.image.icon_cell_submodule()?.template, hidesDisclosure: false)
        
        items.append(HomeSection.setting(title: "", items: [
            HomeSectionItem.notificationItem(viewModel: notificationCellViewModel),
            HomeSectionItem.flashItem(viewModel: flashCellViewModel),
            HomeSectionItem.vibrationItem(viewModel: vibrationCellViewModel),
            HomeSectionItem.voiceItem(viewModel: voiceCellViewModel),
            HomeSectionItem.settingsItem(viewModel: settingsCellViewModel),
            HomeSectionItem.cameraItem(viewModel: cameraCellViewModel),
            HomeSectionItem.albumItem(viewModel: albumCellViewModel)]
        ))
        elements.accept(items)
        
        let selectedEvent = input.selection
        return Output(items: elements, selectedEvent: selectedEvent)
    }

}
