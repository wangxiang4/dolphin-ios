//
//  通知消息实体类
//  Created by 福尔摩翔 on 2022/12/5.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//

import Foundation
import ObjectMapper


// 通知演示OSS文件模型
class OSSFile: CommonEntity {
    
    /**
     * 编号
     */
    var id: String?

    /**
     * 文件名
     */
    var fileName: String?

    /**
     * 容器名称
     */
    var bucketName: String?

    /**
     * 原文件名
     */
    var original: String?

    /**
     * 文件类型
     */
    var type: String?

    /**
     * 文件大小
     */
    var fileSize: Int64?
    
    required init?(map: Map) { super.init(map: map) }
    override init() { super.init() }

    override func mapping(map: Map) {
        super.mapping(map: map)
        
        id <- map["id"]
        fileName <- map["fileName"]
        bucketName <- map["bucketName"]
        original <- map["original"]
        type <- map["type"]
        fileSize <- map["fileSize"]
    }
}
