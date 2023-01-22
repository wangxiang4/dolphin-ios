//
//  用户实体类
//  Created by wangxiang4 on 2022/12/5.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import Foundation
import ObjectMapper
import KeychainAccess

private let keychain = Keychain(service: Configs.App.bundleIdentifier)

class User: CommonEntity {
    
    /** 用户id */
    var id: String?

    /** 用户名 */
    var userName: String?

    /** 昵称 */
    var nickName: String?

    /** 用户类型 */
    var userType: String?

    /** 头像 */
    var avatar: String?

    /** 所属部门ID */
    var deptId: String?

    /** 所属部门名称 */
    var deptName: String?

    /** 邮箱 */
    var email: String?

    /** 菜单按钮权限 */
    var permissions: [String]?

    /** 角色ID权限 */
    var roleIds: [String]?

    /** 手机号 */
    var phone: String?

    /** 用户密码 */
    var password: String?

    /** 用户性别 */
    var sex: String?

    /** 最后登陆IP */
    var loginIp: String?

    /** 最后登陆时间 */
    var loginTime: String?

    /** 用户状态 */
    var status: String?
    
    required init?(map: Map) { super.init(map: map) }
    override init() { super.init() }

    override func mapping(map: Map) {
        super.mapping(map: map)
        
        id <- map["id"]
        userName <- map["userName"]
        nickName <- map["nickName"]
        userType <- map["userType"]
        avatar <- map["avatar"]
        deptId <- map["deptId"]
        deptName <- map["deptName"]
        email <- map["email"]
        permissions <- map["permissions"]
        roleIds <- map["roleIds"]
        phone <- map["phone"]
        password <- map["password"]
        sex <- map["sex"]
        loginIp <- map["loginIp"]
        loginTime <- map["loginTime"]
        status <- map["status"]
        
    }
}

// 持久化用户数据
extension User {

    // 保存用户
    func saveUserInfo() {
        if let json = self.toJSONString() {
            keychain[Configs.CacheKey.userInfoKey] = json
        } else {
            logError("用户无法保存!")
        }
    }

    // 获取用户
    static func getUserInfo() -> User? {
        guard let jsonString = keychain[Configs.CacheKey.userInfoKey] else { return nil }
        return Mapper<User>().map(JSONString: jsonString)
    }

    // 移除用户
    static func removeUserInfo() {
        keychain[Configs.CacheKey.userInfoKey] = nil
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
