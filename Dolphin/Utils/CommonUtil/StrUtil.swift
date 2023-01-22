//
//  字符串工具类
//  Created by 福尔摩翔 on 2022/12/16.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//

import Foundation

class StrUtil {
    
    /**
     * Return whether the string is null or whitespace.
     *
     * @param s The string.
     * @return {@code true}: yes<br> {@code false}: no
     */
    class func isTrimEmpty(_ str: String?) -> Bool {
        var s = str
        return (str == nil || s?.trim().count == 0)
    }
    
    /**
     * Return whether the string is null or 0-length.
     *
     * @param s The string.
     * @return {@code true}: yes<br> {@code false}: no
     */
    class func isEmpty(_ str: String?) -> Bool {
        var s = str
        return (str == nil || s?.count == 0)
    }
    
}
