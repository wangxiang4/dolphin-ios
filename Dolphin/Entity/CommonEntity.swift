//
//  通用模型
//  Created by wangxiang4 on 2022/12/16.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import Foundation
import ObjectMapper
class CommonEntity: BaseEntity {
    
    /** 创建id */
    var createById: String?

    /** 创建者 */
    var createByName: String?

    /** 创建时间 */
    var createTime: String?

    /** 更新id */
    var updateById: String?

    /** 更新者 */
    var updateByName: String?

    /** 更新时间 */
    var updateTime: String?

    /** 备注 */
    var remarks: String?

    /** 删除标志（0代表存在 1代表删除）*/
    var delFlag: String?
    
    required init?(map: Map) { super.init(map: map) }
    override init() { super.init() }

    override func mapping(map: Map) {
        super.mapping(map: map)
        // todo: 转换处理
        createById <- map["createById"]
        createByName <- map["createByName"]
        createTime <- map["createTime"]
        updateById <- map["updateById"]
        updateByName <- map["updateByName"]
        updateTime <- map["updateTime"]
        remarks <- map["remarks"]
        delFlag <- map["delFlag"]
    }
    
}

