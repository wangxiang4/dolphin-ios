//
//  基础视图模型类型
//  Created by 福尔摩翔 on 2022/11/27.
//  Copyright © 2022 entfrm All rights reserved.
//

import RxSwift
import RxCocoa
import ObjectMapper

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}

class ViewModel: NSObject {

    // 当前页码
    var PageCurrent = 1
    
    // 页面大小
    var PageSize = 10

    // 显示状态栏网络加载
    let loading = ActivityIndicator()

    // 显示头部刷新加载
    let headerLoading = ActivityIndicator()
    
    // 显示尾部刷新加载
    let footerLoading = ActivityIndicator()

    // 转换网络请错误
    let bindConverRequestError = PublishSubject<Error>()
    
    // 网络请求错误
    let requestError = PublishSubject<ApiError>()
    
    override init() {
        super.init()
        
        // 转换请求错误
        bindConverRequestError.asObservable().map { error -> ApiError? in
            
            // 响应错误
            var status: Int?, msg: String?
            
            // Alamofire原生实现请求手动抛异常
            if error is ApiError {
                let responseError = error as? ApiError
                status = responseError?.code
                msg = responseError?.errMessage
                
            // Moya扩展请求异常
            } else if error is MoyaError {
                let responseError = error as? MoyaError
                status = responseError?.response?.statusCode
                msg = responseError?.errorDescription
            }
        
            return ResponseException.getRequestError(status ?? -1, msg)
            
        }.filterNil().bind(to: requestError).disposed(by: rx.disposeBag)
        
        // 🤪打印请求错误输出
        requestError.subscribe(onNext: { (error) in
            logError("\(error)")
        }).disposed(by: rx.disposeBag)
        
    }
    
    deinit {
        logDebug("\(type(of: self)): 初始化完成!")
        logResourcesCount()
    }
}
