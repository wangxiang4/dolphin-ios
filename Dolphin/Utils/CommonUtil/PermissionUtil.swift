//
//  应用权限权限工具
//  Created by wangxiang4 on 2022/12/16.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import Foundation

class PermissionUtil {
        
    /** 用户登出 */
    static func logout() {
        (DIContainer.shared.resolve() as HttpRequest).logout()
        User.removeUserInfo()
        AuthManager.removeTokenEnhancer()
        let application: Application = DIContainer.shared.resolve()
        application.window!.rootViewController = LoginViewController(viewModel: LoginViewModel())
    }
    
}
