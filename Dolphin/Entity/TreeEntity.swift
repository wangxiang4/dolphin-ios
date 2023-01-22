//
//  树结构模型
//  Created by 福尔摩翔 on 2022/12/16.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//

import Foundation
import ObjectMapper
class TreeEntity<T: Mappable>: CommonEntity {
    
    /** 父级编号 **/
    var parentId: String?

    /** 名称 */
    var name: String?

    /** 排序 **/
    var sort: Int?

    var children: [T] = []
    
    required init?(map: Map) { super.init(map: map) }
    override init() { super.init() }

    override func mapping(map: Map) {
        super.mapping(map: map)
        // todo: 转换处理
        parentId <- map["parentId"]
        name <- map["name"]
        sort <- map["sort"]
        children <- map["children"]
    }
    
}
