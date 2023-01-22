//
//  基础模型
//  Created by 福尔摩翔 on 2022/12/16.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//

import Foundation
import ObjectMapper
class BaseEntity: Mappable {
    
    /** 多租户ID */
    var tenantId: String?

    /** 当前用户 */
    var currentUser: KiccUser?
    
    required init?(map: Map) {}
    init() {}

    func mapping(map: Map) {
        // todo: 转换处理
        tenantId <- map["tenantId"]
        currentUser <- map["currentUser"]
    }
    
}
