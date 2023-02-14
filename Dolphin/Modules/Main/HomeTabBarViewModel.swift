//
//  首页标签栏目视图模型
//  Created by wangxiang4 on 2022/11/27.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WhatsNewKit

class HomeTabBarViewModel: ViewModel, ViewModelType {

    // 双向绑定输入
    struct Input {
        let whatsNewTrigger: Observable<Void>
    }

    // 双向绑定输出
    struct Output {
        let openWhatsNew: Driver<WhatsNewBlock>
    }
    
    let whatsNewManager: WhatsNewManager

    override init() {
        whatsNewManager = DIContainer.shared.resolve()
    }

    func transform(input: Input) -> Output {
        let whatsNew = whatsNewManager.whatsNew()
        let whatsNewItems = input.whatsNewTrigger.take(1).map { _ in whatsNew }
        return Output(openWhatsNew: whatsNewItems.asDriverOnErrorJustComplete())
    }

    func viewModel(for tabBarItem: HomeTabBarItem) -> ViewModel {
        switch tabBarItem {
        case .home:
            let viewModel = HomeViewModel()
            return viewModel
        case .workbench:
            let viewModel = WorkbenchViewModel()
            return viewModel
        case .message:
            let viewModel = MessageViewModel()
            return viewModel
        case .user:
            let viewModel = UserViewModel()
            return viewModel
        }
    }
}
