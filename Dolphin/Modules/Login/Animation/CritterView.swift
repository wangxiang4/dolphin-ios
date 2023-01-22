//
//  动物动画视图
//  Created by wangxiang4 on 2022/12/13.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import SwiftUI
final class CritterView: UIView {

    // 检查动画是否启动
    var isActiveStartAnimating: Bool {
        guard let activeStartAnimation = activeStartAnimator else { return false }
        return activeStartAnimation.state == .active
    }

    // 检查动画是否狂喜动画
    var isEcstatic: Bool = false {
        didSet {
            mouth.isEcstatic = isEcstatic
            if oldValue != isEcstatic {
                ecstaticAnimation()
            }
        }
    }

    // 检查动画是否害羞动画
    var isShy: Bool = false {
        didSet {
            leftArm.isShy = isShy
            rightArm.isShy = isShy
            guard oldValue != isShy else { return }
            shyAnimation()
        }
    }

    // 检查动画是否窥视动画
    var isPeeking: Bool = false {
        didSet {
            guard oldValue != isPeeking else { return }
            togglePeekingState()
        }
    }

    private let body = Body()
    private let head = Head()
    private let leftArm = LeftArm()
    private let leftEar = LeftEar()
    private let leftEarMask = LeftEarMask()
    private let leftEye = LeftEye()
    private let mouth = Mouth()
    private let muzzle = Muzzle()
    private let nose = Nose()
    private let rightArm = RightArm()
    private let rightEar = RightEar()
    private let rightEarMask = RightEarMask()
    private let rightEye = RightEye()

    private lazy var parts: [CritterAnimatable] = {
        return [self.body,
                self.head,
                self.leftEar,
                self.rightEar,
                self.leftEarMask,
                self.rightEarMask,
                self.leftEye,
                self.rightEye,
                self.muzzle,
                self.nose,
                self.mouth,
                self.leftArm,
                self.rightArm]
    }()

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setUpView()
    }

    // 设置视图布局
    private func setUpView() {
        theme.backgroundColor = themeService.attribute { $0.loginPrimaryLight }
        setUpMask()

        addSubview(body)
        addSubview(head)

        head.addSubview(leftEar)
        head.addSubview(rightEar)
        head.addSubview(leftEarMask)
        head.addSubview(rightEarMask)
        head.addSubview(leftEye)
        head.addSubview(rightEye)
        head.addSubview(muzzle)

        muzzle.addSubview(nose)
        muzzle.addSubview(mouth)

        addSubview(leftArm)
        addSubview(rightArm)
    }

    private func setUpMask() {
        mask = UIView(frame: bounds)
        mask?.backgroundColor = .black
        mask?.layer.cornerRadius = bounds.width / 2
    }

    // MARK: - Animation
    private var neutralAnimator: UIViewPropertyAnimator?
    private var activeStartAnimator: UIViewPropertyAnimator?
    private var activeEndAnimator: UIViewPropertyAnimator?
    private var savedState = [SavedState]()

    // 开始头部旋转动画
    func startHeadRotation(startAt fractionComplete: Float) {
        let shouldSaveCurrentState = activeEndAnimator != nil
        stopAllAnimations()

        // 检查当前状态是否保存,保存可以让下一次旋转的起始位置为当前保存位置
        if shouldSaveCurrentState {
            saveCurrentState()
        }

        // 设置部件活动开始动画
        activeStartAnimator = UIViewPropertyAnimator(
            duration: 0.2,
            curve: .easeIn,
            animations: { self.savedState.isEmpty ? self.focusCritterInitialState() : self.restoreToSavedState() })

        // 设置活动结束动画
        activeEndAnimator = UIViewPropertyAnimator(
            duration: 0.2,
            curve: .linear,
            animations: focusCritterFinalState
        )

        // 动画完成执行
        activeStartAnimator?.addCompletion { [weak self] _ in
            self?.focusCritterInitialState()
            self?.activeEndAnimator?.fractionComplete = CGFloat(fractionComplete)
        }

        activeStartAnimator?.startAnimation()
    }

    // 更新头部旋转动画
    func updateHeadRotation(to fractionComplete: Float) {
        activeEndAnimator?.fractionComplete = CGFloat(fractionComplete)
    }

    // 停止头部旋转动画
    func stopHeadRotation() {
        if let neutralAnimation = neutralAnimator, neutralAnimation.state == .inactive {
            return
        }
        
        // 检查当前状态是否保存,保存可以让下一次旋转的起始位置为当前保存位置
        let shouldSaveCurrentState = activeEndAnimator != nil

        stopAllAnimations()

        if shouldSaveCurrentState {
            saveCurrentState()
        }

        // 使用中性动画还原动画默认3D位置
        neutralAnimator = UIViewPropertyAnimator(duration: 0.1725, curve: .easeIn) {
            self.parts.applyInactiveState()
        }

        neutralAnimator?.startAnimation()
    }

    // 狂喜动画
    private func ecstaticAnimation() {
        let duration = 0.125
        let eyeAnimationKey = "eyeCrossFade"
        leftEye.layer.removeAnimation(forKey: eyeAnimationKey)
        rightEye.layer.removeAnimation(forKey: eyeAnimationKey)

        let crossFade = CABasicAnimation(keyPath: "contents")
        crossFade.duration = duration
        crossFade.fromValue = isEcstatic ? UIImage.Critter.eye.cgImage : UIImage.Critter.doeEye.cgImage
        crossFade.toValue = isEcstatic ? UIImage.Critter.doeEye.cgImage : UIImage.Critter.eye.cgImage
        crossFade.fillMode = .forwards
        crossFade.isRemovedOnCompletion = false

        leftEye.layer.add(crossFade, forKey: eyeAnimationKey)
        rightEye.layer.add(crossFade, forKey: eyeAnimationKey)

        let dimension = isEcstatic ? 12.7 : 11.7
        let ecstaticAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeIn) {
            self.leftEye.layer.bounds = CGRect(x: 0, y: 0, width: dimension, height: dimension)
            self.rightEye.layer.bounds = CGRect(x: 0, y: 0, width: dimension, height: dimension)
            self.mouth.applyEcstaticState()
        }

        ecstaticAnimator.startAnimation()
    }
    
    // 切换窥视动画
    private func togglePeekingState() {
        let animation = isPeeking ? parts.applyPeekState : parts.applyUnPeekState
        let peekAnimator = UIViewPropertyAnimator(duration: 0.15, curve: .easeIn, animations: animation)
        peekAnimator.startAnimation()
    }
    
    // 输入密码时显示害羞动画
    private func shyAnimation() {
        let shyAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeIn) {
            self.leftArm.applyShyState()
            self.rightArm.applyShyState()
        }

        shyAnimator.startAnimation()
    }

    // 停止目前所有动画
    private func stopAllAnimations() {
        neutralAnimator?.stopAnimation(true)
        neutralAnimator = nil

        activeStartAnimator?.stopAnimation(true)
        activeStartAnimator = nil

        activeEndAnimator?.stopAnimation(true)
        activeEndAnimator = nil
    }

    // 初始启动动画
    private func focusCritterInitialState() {
        parts.applyActiveStartState()
    }

    // 最终结束动画
    private func focusCritterFinalState() {
        parts.applyActiveEndState()
    }
    
    // 保存当前动画位置
    private func saveCurrentState() {
        savedState = parts.map { $0.currentState() }
    }

    // 恢复到保存当前动画位置
    private func restoreToSavedState() {
        savedState.forEach { $0() }
    }
}
