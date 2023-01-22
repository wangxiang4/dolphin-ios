//
//  网络请求核心
//  Created by wangxiang4 on 2022/11/27.
//  Copyright © 2022 entfrm All rights reserved.
//

import Moya
import RxSwift
import Alamofire

class OnlineProvider<Target> where Target: Moya.TargetType {
    
    // 网络在线
    fileprivate let online: Observable<Bool>
    
    // 网络请求
    fileprivate let provider: MoyaProvider<Target>
    
    // 初始化请求参数公共
    // @Param endpointClosure 将 enum 值映射成一个 Endpoint 实例对象
    // @Param requestClosure  将一个 Endpoint 转换成一个实际的 URLRequest
    // @Param stubClosure     设置请求延迟时间
    // @Param session         创建Alamofire请求会话
    // @Param plugins         请求生命周期回调
    // @Param trackInflights  是否取消重复请求
    // @Param online          网络是否处于在线状况
    init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
         stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider<Target>.neverStub,
         session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
         plugins: [PluginType] = [],
         trackInflights: Bool = false,
         online: Observable<Bool> = connectedToInternet()) {
        self.online = online
        self.provider = MoyaProvider(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, session: session, plugins: plugins, trackInflights: trackInflights)
    }

    // 发起请求
    // @Param token 请求ApiTarget对象
    func request(_ token: Target) -> Observable<Moya.Response> {
        let actualRequest = provider.rx.request(token)
        return online
        // 过滤掉当前网络不在线的请求
        .ignore(value: false)
        // 防止双向绑定互相监听调用产生死循环,取1来确保我们只调用一次,避免死循环
        .take(1)
        // 将联机状态变成网络请求
        .flatMap { _ in
            actualRequest.filterSuccessfulStatusCodes()
        }
    }
}

// 网络提供配置类型
protocol NetworkingType {
    associatedtype T: TargetType
    var provider: OnlineProvider<T> { get }
    static func defaultNetworking() -> Self
}

// Api网络提供配置
struct ApiNetworking: NetworkingType {
    typealias T = ApiTarget
    let provider: OnlineProvider<T>
    
    static func defaultNetworking() -> Self {
        return ApiNetworking(provider: newProvider(plugins))
    }

    func request(_ token: T) -> Observable<Moya.Response> {
        let actualRequest = self.provider.request(token)
        return actualRequest
    }
    
}

extension NetworkingType {
    
    // 转换Endpoint实例对象
    static func endpointsClosure<T>() -> (T) -> Endpoint where T: TargetType {
        return { target in
            let endpoint = MoyaProvider.defaultEndpointMapping(for: target)
            return endpoint
        }
    }

    // 是否返回存根响应
    static func APIKeysBasedStubBehaviour<T>(_: T) -> Moya.StubBehavior {
        return .never
    }

    // 请求生命周期回调
    static var plugins: [PluginType] {
        var plugins: [PluginType] = []
        plugins.append(NetworkLoggerPlugin())
        return plugins
    }

    // 解析Endpoint为URLRequest对象
    static func endpointResolver() -> MoyaProvider<T>.RequestClosure {
        return { (endpoint, closure) in
            do {
                // 端点url请求
                var request = try endpoint.urlRequest()
                request.httpShouldHandleCookies = false
                closure(.success(request))
            } catch {
                logError(error.localizedDescription)
            }
        }
    }
}

// 创建默认网络请求提供
private func newProvider<T>(_ plugins: [PluginType]) -> OnlineProvider<T> {
    return OnlineProvider(endpointClosure: ApiNetworking.endpointsClosure(),
                        requestClosure: ApiNetworking.endpointResolver(),
                        stubClosure: ApiNetworking.APIKeysBasedStubBehaviour,
                        plugins: plugins)
}
