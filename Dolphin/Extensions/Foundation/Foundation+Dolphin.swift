//
//  扩展基础库
//  Created by 福尔摩翔 on 2022/12/5.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//

import Foundation

extension Int {

    func sizeFromKB() -> String {
        return (self*1024).sizeFromByte()
    }

    func sizeFromByte() -> String {
        return ByteCountFormatter.string(fromByteCount: Int64(self), countStyle: .file)
    }

    func kFormatted() -> String {
        let sign = ((self < 0) ? "-" : "" )
        if self < 1000 {
            return "\(sign)\(self)"
        }
        let num = fabs(self.double)
        let exp: Int = Int(log10(num) / 3.0 )
        let units: [String] = ["K", "M", "G", "T", "P", "E"]
        let roundedNum: Double = round(10 * num / pow(1000.0, Double(exp))) / 10
        return "\(sign)\(roundedNum)\(units[exp-1])"
    }
}


extension String {
    
    // 检查是否为空字符串
    var isBlank: Bool {
        // 扔掉空格和换行符
        let trimmedStr = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedStr.isEmpty
    }
 
}
