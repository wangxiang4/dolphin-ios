//
//  返回异常处理
//  Created by wangxiang4 on 2022/12/15.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import Foundation
import Moya

// 错误类型
typealias MoyaError = Moya.MoyaError

class ApiError: Swift.Error {
    
    var code: Int?
    
    var errMessage: String?
    
    init(_ code: Int?, _ errMessage: String?) {
        self.code = code
        self.errMessage = errMessage
    }
}

class ResponseException {
    
    class func getRequestError(_ status: Int, _ msg: String?) -> ApiError {
        var errMessage = ""
        
        switch status {
        case 401: errMessage = "用户没有权限（令牌、用户名、密码错误）"
        case 403: errMessage = "用户得到授权,但是访问是被禁止的!"
        case 404: errMessage = "资源不存在"
        case 405: errMessage = "操作异常,不允许的请求方法"
        case 408: errMessage = "网络请求超时"
        case 424: errMessage = "令牌过期,请重新登录!"
            PermissionUtil.logout()
        case 426: errMessage = "用户名或密码错误或者当前用户不存在"
        case 428: errMessage = "验证码错误,请重新输入!"
        case 429: errMessage = "请求过频繁"
        case 500: errMessage = "服务器错误,请联系管理员!"
        case 501: errMessage = "网络未实现"
        case 502: errMessage = "网络错误"
        case 503: errMessage = "服务器不可用"
        case 504: errMessage = "网络超时"
        case 505: errMessage = "http版本不支持该请求!"
        default: errMessage = StrUtil.isEmpty(msg) ? "操作异常,请联系系统管理员!" : msg!
        }
        
        return ApiError(status, errMessage)
    }
    
}
