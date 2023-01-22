//
//  数组工具类
//  Created by 福尔摩翔 on 2022/12/18.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//

import Foundation

class ArrayUtil {
    
    /**
     * Return the array is empty.
     *
     * @param array The array.
     * @return {@code true}: yes<br>{@code false}: no
     */
    class func isEmpty(_ arr: [AnyObject]?) -> Bool {
        return arr?.count == 0
    }
    
}
