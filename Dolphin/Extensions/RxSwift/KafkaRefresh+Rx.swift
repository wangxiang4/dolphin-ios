//
//  扩展下拉刷新库
//  Created by wangxiang4 on 2022/12/5.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import KafkaRefresh

extension Reactive where Base: KafkaRefreshControl {

    // 处理下拉刷新回调
    public var isAnimating: Binder<Bool> {
        return Binder(self.base) { refreshControl, active in
            if active {
                // todo: 下拉刷新开始
            } else {
                // todo: 下拉刷新结束
                refreshControl.endRefreshing()
            }
        }
    }
}
