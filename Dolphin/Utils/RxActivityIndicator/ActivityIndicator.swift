//
//  监听可观测活动对象序列
//  如果正在进行至少一个序列计算,则将发送 true
//  当所有活动完成时,将发送 false
//  Created by wangxiang4 on 2022/11/27.
//  Copyright © 2022 entfrm All rights reserved.
//

#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif

// 声明周期跟随source的可释放资源,会持有source,持有一个释放方法,在source取消订阅的时候,会调用dispose方法
private struct ActivityDisposableResource<E>: ObservableConvertibleType, Disposable {
    private let _source: Observable<E>
    private let _dispose: Cancelable

    init(source: Observable<E>, disposeAction: @escaping () -> Void) {
        _source = source
        _dispose = Disposables.create(with: disposeAction)
    }

    func dispose() {
        _dispose.dispose()
    }

    func asObservable() -> Observable<E> {
        return _source
    }
}

// 可观测活动追踪
public class ActivityIndicator: SharedSequenceConvertibleType {
    
    // 信号元素类型为Bool
    public typealias Element = Bool
    
    // 信号序列策略为Driver(永不失败,一定在主线程订阅,每次新的订阅,都会把最后一个信号发送一次)
    public typealias SharingStrategy = DriverSharingStrategy

    // 观测递归锁
    private let _lock = NSRecursiveLock()
    // 记录监测的尚未完成的信号源个数
    private let _relay = BehaviorRelay(value: 0)
    // 发送信号源的数据
    private let _loading: SharedSequence<SharingStrategy, Bool>

    public init() {
        // 过滤重复的信号量,减少发生次数
        _loading = _relay.asDriver()
            .map { $0 > 0 }
            .distinctUntilChanged()
    }

    fileprivate func trackActivityOfObservable<Source: ObservableConvertibleType>(_ source: Source) -> Observable<Source.Element> {
        return Observable.using({ () -> ActivityDisposableResource<Source.Element> in
            self.increment()
            return ActivityDisposableResource(source: source.asObservable(), disposeAction: self.decrement)
        }, observableFactory: { value in
            return value.asObservable()
        })
    }

    // 观测整条序列,加入一个可观测活动时加1
    private func increment() {
        _lock.lock()
        _relay.accept(_relay.value + 1)
        _lock.unlock()
    }

    // 观测整条序列,销毁时一个可观测活动时减1
    private func decrement() {
        _lock.lock()
        _relay.accept(_relay.value - 1)
        _lock.unlock()
    }

    // 发送信号源的数据转换协议
    public func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        return _loading
    }
}

extension ObservableConvertibleType {
    // 给信号源类型扩展,添加追踪监测方法
    public func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<Element> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}
