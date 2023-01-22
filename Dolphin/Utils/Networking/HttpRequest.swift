//
//  发送请求
//  Created by 福尔摩翔 on 2022/12/7.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//

import RxSwift
import RxCocoa
import ObjectMapper
import Moya
import Moya_ObjectMapper
import Alamofire
import CryptoSwift

class HttpRequest {
    let apiProvider: ApiNetworking = ApiNetworking.defaultNetworking()
}

extension HttpRequest {

    // 下载文件
    func downloadFile(url: URL, fileName: String?) -> Single<Void> {
        return requestVoid(.download(url: url, fileName: fileName))
    }

    // 请求获取token访问令牌
    func requestAccessToken(username: String, password: String) -> Single<TokenEnhancer> {
        return Single.create { single in
            // 微服务网关密码ase对称加密
            let aes = try? AES(key: Array(Configs.App.gatewayAseEncodeSecret.utf8), blockMode: CFB(iv: Array(Configs.App.gatewayAseEncodeSecret.utf8)), padding: .noPadding)
            let encrypted = try? aes?.encrypt(password.bytes)
            let encryptedBase64 = encrypted?.toBase64()
            // OAuth2.0 认证
            var params: Parameters = [:]
            params["username"] = username
            params["password"] = encryptedBase64
            params["grant_type"] = "password"
            params["scope"] = "server"
            AF.request("\(Configs.App.baseUrl)/auth_proxy/oauth/token",
                       method: .post,
                       parameters: params,
                       encoding: URLEncoding.default,
                       headers: [
                        "Authorization": "Basic dGVzdDp0ZXN0",
                        "Content-Type": "application/x-www-form-urlencoded; charset=utf-8",
                        "Accept": "application/json"
                       ]
            ).responseJSON(completionHandler: { (response) in
                
                // 根据请求码进行筛选,200～299范围内有效
                if response.response!.statusCode >= 200 && response.response!.statusCode < 300 {
                    if let json = response.value as? [String: Any], let tokenEnhancer = Mapper<TokenEnhancer>().map(JSON: json) {
                        single(.success(tokenEnhancer))
                        return
                    }
                }
                
                // 截取请求错误信息
                let error = response.value as! [String: Any]
                single(.failure(ApiError(response.response?.statusCode, error["msg"] as! String)))
            })
            return Disposables.create {}
        }.observe(on: MainScheduler.instance)
    }
    
    // 获取当前用户信息
    func getUserInfo() -> Single<BaseResultResponseObject<User>> {
        return requestObject(.getUserInfo, type: BaseResultResponseObject.self)
    }
    
    // 用户登出
    func logout() -> Single<Void> {
        return requestVoid(.logout)
    }
    
    // 获取文件列表
    func listFile(current: Int, size: Int) -> Single<BaseResultResponseArray<OSSFile>> {
        return requestObject(.listFile(current: current, size: size), type: BaseResultResponseArray.self)
    }
    
}

extension HttpRequest {
    
    // 请求转换json
    private func request(_ target: ApiTarget) -> Single<Any> {
        return apiProvider.request(target)
            .mapJSON()
            .observe(on: MainScheduler.instance)
            .asSingle()
    }
    
    // 请求转换void
    private func requestVoid(_ target: ApiTarget)-> Single<Void> {
        return apiProvider.request(target)
            .mapToVoid()
            .observe(on: MainScheduler.instance)
            .asSingle()
    }
    
    // 请求无转换
    private func requestWithoutMapping(_ target: ApiTarget) -> Single<Moya.Response> {
        return apiProvider.request(target)
            .observe(on: MainScheduler.instance)
            .asSingle()
    }

    // 请求转换对象
    private func requestObject<T: BaseMappable>(_ target: ApiTarget, type: T.Type) -> Single<T> {
        return apiProvider.request(target)
            .mapObject(T.self)
            .observe(on: MainScheduler.instance)
            .asSingle()
    }

    // 请求转换数组
    private func requestArray<T: BaseMappable>(_ target: ApiTarget, type: T.Type) -> Single<[T]> {
        return apiProvider.request(target)
            .mapArray(T.self)
            .observe(on: MainScheduler.instance)
            .asSingle()
    }
    
}
