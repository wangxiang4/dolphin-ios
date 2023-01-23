//
//  依赖注入管理容器
//  https://github.com/Swinject/Swinject/tree/master/Documentation
//  Created by wangxiang4 on 2022/12/5.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import Swinject

final class DIContainer {
    
    static let shared = DIContainer()
    
    let container: Container = Container()
    let assembler: Assembler
    
    init() {
        // 初始化组装ioc对象
        assembler = Assembler(
            [
                AppAssembly()
            ],
            container: container)
    }
    
    // 根据返回类型获取ioc实例
    func resolve<T>() -> T {
        guard let resolvedType = container.resolve(T.self) else {
            fatalError()
        }
        return resolvedType
    }
    
    // 根据返回类型跟注册名称获取ioc实例
    func resolve<T>(registrationName: String?) -> T {
        guard let resolvedType = container.resolve(T.self, name: registrationName) else {
            fatalError()
        }
        return resolvedType
    }
    
    // 根据返回类型传单个参
    func resolve<T, Arg>(argument: Arg) -> T {
        guard let resolvedType = container.resolve(T.self, argument: argument) else {
            fatalError()
        }
        return resolvedType
    }
    
    // 根据返回类型传多个参
    func resolve<T, Arg1, Arg2>(arguments arg1: Arg1, _ arg2: Arg2) -> T {
        guard let resolvedType = container.resolve(T.self, arguments: arg1, arg2) else {
            fatalError()
        }
        return resolvedType
    }
    
    // 根据返回类型跟注册名称传单个参
    func resolve<T, Arg>(name: String?, argument: Arg) -> T {
        guard let resolvedType = container.resolve(T.self, name: name, argument: argument) else {
            fatalError()
        }
        return resolvedType
    }
    
    // 根据返回类型跟注册名称传多个参
    func resolve<T, Arg1, Arg2>(name: String?, arguments arg1: Arg1, _ arg2: Arg2) -> T {
        guard let resolvedType = container.resolve(T.self, name: name, arguments: arg1, arg2) else {
            fatalError()
        }
        return resolvedType
    }
    
}
