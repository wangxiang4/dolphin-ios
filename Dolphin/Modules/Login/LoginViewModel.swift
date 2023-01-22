//
//  登录视图模型
//  Created by wangxiang4 on 2022/12/14.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt
import Toast_Swift

class LoginViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let loginTrigger: PublishSubject<Void>
    }

    struct Output {
    }
    
    // 用户名称
    let username = BehaviorRelay(value: "admin")
    // 用户密码
    let password = BehaviorRelay(value: "123456")
    
    let httpRequest: HttpRequest = DIContainer.shared.resolve()
    
    // 当前用户信息保存
    var userInfoSaved = PublishSubject<Void>()
    
    func transform(input: Input) -> Output {

        let loginRequest = input.loginTrigger.flatMapLatest { [weak self] in
            guard let self = self else { return Observable.just(RxSwift.Event.next(TokenEnhancer())) }
            return self.httpRequest.requestAccessToken(username: self.username.value, password: self.password.value)
                .trackActivity(self.loading)
                .materialize()
        }.share()
        
        // 登录成功
        loginRequest.elements().subscribe(onNext: { [weak self] tokenEnhancer in
            AuthManager.setTokenEnhancer(tokenEnhancer: tokenEnhancer)
            self?.userInfoSaved.onNext(())
        }).disposed(by: rx.disposeBag)
        
        // 获取当前用户信息
        let getUserInfo = userInfoSaved.flatMapLatest { [weak self] in
            guard let self = self else { return Observable.just(RxSwift.Event.next(BaseResultResponseObject<User>())) }
            return self.httpRequest.getUserInfo()
                .trackActivity(self.loading)
                .materialize()
        }.share()
        
        // 获取用户成功
        getUserInfo.elements().subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            if result.code == result.SUCCESS, let user = result.data {
                user.saveUserInfo()
                let application: Application = DIContainer.shared.resolve()
                let homeTabBarVC: HomeTabBarViewController = HomeTabBarViewController(viewModel: HomeTabBarViewModel())
                let initialSplitVC: InitialSplitViewController = InitialSplitViewController(viewModel: nil)
                let navigationC = NavigationController(rootViewController: initialSplitVC)
                let splitVC = SplitViewController()
                splitVC.viewControllers = [homeTabBarVC, navigationC]

                // xxx:临时解决方案 RAMAnimatedTabBarController 首次加载需适配当前设备,会导致短暂闪白,延长动画时间
                UIView.transition(with: application.window!,	
                                  duration: UserDefaults.standard.integer(forKey: Configs.CacheKey.firstLoadKey) == 0 ? 2.3 : 0.5,
                                  options: .transitionCrossDissolve, animations: {
                    application.window!.rootViewController = splitVC
                }, completion: nil)
                
                // 更新首次加载状态
                if UserDefaults.standard.integer(forKey: Configs.CacheKey.firstLoadKey) == 0 {
                    UserDefaults.standard.set(1, forKey: Configs.CacheKey.firstLoadKey)
                }
            } else {
                self.requestError.onNext(ApiError(result.code, result.msg))
            }
        }).disposed(by: rx.disposeBag)
        
        // 登录失败
        loginRequest.errors().bind(to: bindConverRequestError).disposed(by: rx.disposeBag)
        // 获取用户失败
        getUserInfo.errors().bind(to: bindConverRequestError).disposed(by: rx.disposeBag)
        requestError.subscribe(onNext: { (error) in
            User.removeUserInfo()
            AuthManager.removeTokenEnhancer()
        }).disposed(by: rx.disposeBag)
        
        return Output()
    }
}
