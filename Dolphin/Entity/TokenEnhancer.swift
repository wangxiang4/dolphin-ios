//
//  令牌增强输出对象
//  Created by wangxiang4 on 2022/12/5.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import Foundation
import ObjectMapper
struct TokenEnhancer: Mappable {

    /** 访问token */
    var access_token: String?

    /** 客户端ID */
    var clientId: String?

    /** 过期时间(毫秒为单位) */
    var expires_in: Int?

    /** 证书字段 */
    var license: String?

    /** 刷新token */
    var refresh_token: String?

    /** 授权权限范围 */
    var scope: String?

    /** token类型 */
    var token_type: String?

    /** 用户信息 */
    var user_info: DolphinUser?
    
    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        // todo: 转换处理
        access_token <- map["access_token"]
        clientId <- map["clientId"]
        expires_in <- map["expires_in"]
        license <- map["license"]
        refresh_token <- map["refresh_token"]
        scope <- map["scope"]
        token_type <- map["token_type"]
        user_info <- map["user_info"]
    }
    
}
