//
//  登录授权管理
//  https://github.com/kishikawakatsumi/KeychainAccess
//  Created by wangxiang4 on 2022/12/5.
//  Copyright © 2022 dolphin-community. All rights reserved.
//
import KeychainAccess
import ObjectMapper
import RxSwift
import RxCocoa

class AuthManager {

    fileprivate let keychain = Keychain(service: Configs.App.bundleIdentifier)

    // 令牌对象更改监听
    let tokenChanged = PublishSubject<TokenEnhancer?>()

    var tokenEnhancer: TokenEnhancer? {
        get {
            guard let jsonString = keychain[Configs.CacheKey.tokenEnhancerKey] else { return nil }
            return Mapper<TokenEnhancer>().map(JSONString: jsonString)
        }
        set {
            if let tokenEnhancer = newValue, let jsonString = tokenEnhancer.toJSONString() {
                keychain[Configs.CacheKey.tokenEnhancerKey] = jsonString
            } else {
                keychain[Configs.CacheKey.tokenEnhancerKey] = nil
            }
            tokenChanged.onNext(newValue)
        }
    }

    // 设置令牌对象
    class func setTokenEnhancer(tokenEnhancer: TokenEnhancer) {
        let authManager: AuthManager = DIContainer.shared.resolve()
        authManager.tokenEnhancer = tokenEnhancer
    }

    // 移除令牌对象
    class func removeTokenEnhancer() {
        let authManager: AuthManager = DIContainer.shared.resolve()
        authManager.tokenEnhancer = nil
    }

}
