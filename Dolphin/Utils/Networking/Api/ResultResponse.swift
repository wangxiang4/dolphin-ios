//
//  结果响应模型
//  Created by wangxiang4 on 2022/12/7.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseResultResponse: Mappable {
    
    /**
     * 成功标记
     */
    let SUCCESS = 200

    /**
     * 失败标记
     */
    let FAIL = 500

    /**
     * 未认证
     */
    let UNAUTH = 401
    
    /**
     * 状态编码
     */
    var code: Int?

    /**
     * 提示消息
     */
    var msg: String?

    /**
     * 结果集数量统计
     */
    var total: Int?

    required init?(map: Map) {}
    init() {}
    
    func mapping(map: Map) {
        code <- map["code"]
        msg <- map["msg"]
        total <- map["total"]
    }
}

// xxx: ObjectMapper解析泛型对象,必须实现Mappable,由于swift集合类型无法实现Mappable,导致json映射始终为空,目前抽离公共类直接写死,等待官方出解决方案
class BaseResultResponseArray<T: Mappable>: BaseResultResponse {
    
    /**
     * 结果集
     */
    var data: [T]?
    
    override required init?(map: Map) { super.init(map: map) }
    override init() { super.init() }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        data <- map["data"]
    }
    
}

class BaseResultResponseObject<T: Mappable>: BaseResultResponse {
    
    /**
     * 结果集
     */
    var data: T?
    
    override required init?(map: Map) { super.init(map: map) }
    override init() { super.init() }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        data <- map["data"]
    }
    
}
