//
//  扩展安全框架用户信息
//  Created by 福尔摩翔 on 2022/12/16.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//

import Foundation
import ObjectMapper
class KiccUser: Mappable {
    
    /** 用户id */
    var id: String?

    /** 用户名称 */
    var username: String?

    /** 用户密码 */
    var password: String?

    /** 部门ID */
    var deptId: String?

    /** 用户手机号 */
    var phone: String?

    /** 账户是否被冻结 */
    var enabled: Bool?

    /** 多租户ID */
    var tenantId: String?

    /** 用户按钮权限 */
    var authorities: [[String: String]]?

    /** 帐户未锁定 */
    var accountNonLocked: Bool?

    /** 帐户未过期 */
    var accountNonExpired: Bool?

    /** 凭证未过期 */
    var credentialsNonExpired: Bool?
    
    required init?(map: Map) {}
    init() {}

    func mapping(map: Map) {
        // todo: 转换处理
        id <- map["id"]
        username <- map["username"]
        password <- map["password"]
        deptId <- map["deptId"]
        phone <- map["phone"]
        enabled <- map["enabled"]
        tenantId <- map["tenantId"]
        authorities <- map["authorities"]
        accountNonLocked <- map["accountNonLocked"]
        accountNonExpired <- map["accountNonExpired"]
        credentialsNonExpired <- map["credentialsNonExpired"]
    }
    
}
