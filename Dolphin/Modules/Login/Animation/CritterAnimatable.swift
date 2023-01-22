//
//  3D动画执行接口
//  Created by wangxiang4 on 2022/12/13.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import SwiftUI

typealias SavedState = () -> Void

// 3D动画部件执行协议
protocol CritterAnimatable {
    func currentState() -> SavedState
    func applyActiveStartState()
    func applyActiveEndState()
    func applyInactiveState()
    func applyPeekState()
    func applyUnPeekState()
}

// 3D动画部件执行默认实现
extension CritterAnimatable where Self: UIView {
    
    func currentState() -> SavedState {
        let currentState = layer.transform
        return {
            self.layer.transform = currentState
        }
    }

    func applyActiveStartState() { }

    func applyActiveEndState() { }
    
    func applyInactiveState() {
        layer.transform = .identity
    }

    func applyPeekState() { }

    func applyUnPeekState() { }
}

// 执行集合中的3D动画
extension Sequence where Iterator.Element == CritterAnimatable {

    func applyActiveStartState() {
        forEach { $0.applyActiveStartState() }
    }

    func applyActiveEndState() {
        forEach { $0.applyActiveEndState() }
    }

    func applyInactiveState() {
        forEach { $0.applyInactiveState() }
    }

    func applyPeekState() {
        forEach { $0.applyPeekState() }
    }

    func applyUnPeekState() {
        forEach { $0.applyUnPeekState() }
    }
}
