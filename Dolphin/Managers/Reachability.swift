//
//  网络连接状况管理
//  Created by wangxiang4 on 2022/12/5.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import RxSwift
import Alamofire

// 一个可观察的,当应用程序上线时完成(可能立即完成)
func connectedToInternet() async -> Observable<Bool> {
    return ReachabilityManager.shared.reach
}

private class ReachabilityManager: NSObject {

    static let shared = ReachabilityManager()

    let reachSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    var reach: Observable<Bool> {
        return reachSubject.asObservable()
    }

    override init() {
        super.init()
        NetworkReachabilityManager.default?.startListening(onUpdatePerforming: { (status) in
            switch status {
            case .notReachable:
                self.reachSubject.onNext(false)
            case .reachable:
                self.reachSubject.onNext(true)
            case .unknown:
                self.reachSubject.onNext(false)
            }
        })
    }
}
