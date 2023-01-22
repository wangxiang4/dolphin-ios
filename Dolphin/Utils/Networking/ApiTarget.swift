//
//  Api目标类型枚举
//  https://github.com/Moya/Moya/tree/master/docs_CN
//  Created by 福尔摩翔 on 2022/12/7.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//

import RxSwift
import Moya
import Alamofire

// 获取沙盒下载文件资源目录
private let assetDir: URL = {
    let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return directoryURLs.first ?? URL(fileURLWithPath: NSTemporaryDirectory())
}()

enum ApiTarget {
        
    // 下载文件接口
    case download(url: URL, fileName: String?)
    
    // 获取用户信息
    case getUserInfo
    
    // 用户登出
    case logout
    
    // 获取文件列表
    case listFile(current: Int, size: Int)
    
}

extension ApiTarget: TargetType {
 
    // 请求基础路径
    var baseURL: URL {
        switch self {
        case .download(let url, _):
            return url
        default:
            return Configs.App.baseUrl.url!
        }
    }
    
    // 请求路径
    var path: String {
        switch self {
        case .download: return ""
        case .getUserInfo: return "/system_proxy/system/user/info"
        case .logout: return "/auth_proxy/token/logout"
        case .listFile: return "/system_proxy/system/file/list"
        }
    }
    
    // 请求类型
    var method: Moya.Method {
        switch self {
        case nil:
            return .put
        case nil:
            return .post
        case .logout:
            return .delete
        default:
            return .get
        }
    }
    
    // 参数配置
    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        switch self {
        case .listFile(let current, let size):
            params["current"] = current
            params["size"] = size
        default: break
        }
        return params
    }
    
    // 请求头配置
    var headers: [String: String]? {
        let authManager: AuthManager = DIContainer.shared.resolve()
        if let accessToken = authManager.tokenEnhancer?.access_token {
            return ["Authorization": "Bearer \(accessToken)"]
        }
        return nil
    }
    
    // 本地沙盒目录
    var localLocation: URL {
        switch self {
        case .download(_, let fileName):
            // 拼接下载目录
            if let fileName = fileName {
                return assetDir.appendingPathComponent(fileName)
            }
        default: break
        }
        return assetDir
    }
    
    // 下载目录位置,包含旧文件时候会删除
    var downloadDestination: DownloadDestination {
        return { _, _ in return (self.localLocation, .removePreviousFile) }
    }

    // http请求任务执行
    public var task: Task {
        switch self {
        case .download:
            return .downloadDestination(downloadDestination)
        default:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            }
            return .requestPlain
        }
    }
    
}
