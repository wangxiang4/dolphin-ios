//
//  应用程序依赖注入装配
//  Created by 福尔摩翔 on 2022/12/5.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//

import Swinject

final class AppAssembly: Assembly {
    
    func assemble(container: Container) {
        
        // 应用程序
        container.register(Application.self) { resolver in
            Application()
        }.inObjectScope(.container)
        
        // 应用程序委托
        container.register(AppDelegate.self) { resolver in
            AppDelegate()
        }.inObjectScope(.container)
        
        // 登录授权管理
        container.register(AuthManager.self) { resolver in
            AuthManager()
        }.inObjectScope(.container)
        
        // 第三方依赖库管理
        container.register(LibsManager.self) { resolver in
            LibsManager()
        }.inObjectScope(.container)
        
        // 程序新功能特性管理
        container.register(WhatsNewManager.self) { resolver in
            WhatsNewManager()
        }.inObjectScope(.container)
        
        // 网络请求
        container.register(HttpRequest.self) { resolver in
            HttpRequest()
        }.inObjectScope(.container)
    }
    
}
