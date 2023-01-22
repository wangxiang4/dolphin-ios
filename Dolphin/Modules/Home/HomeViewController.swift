//
//  主页视图控制器
//  Created by wangxiang4 on 2022/11/29.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import SwiftUI
import RxSwift
import RxCocoa
import RxDataSources
import AVFoundation
import Toast_Swift
import Foundation
import Photos

// xib资源列标识符
private let reuseIdentifier = R.reuseIdentifier.homeCell.identifier
class HomeViewController: TableViewController {
   
    let syntesizer = AVSpeechSynthesizer(),
        utterance = AVSpeechUtterance()
    var device: AVCaptureDevice?
    var audioPlayer: AVAudioPlayer?
    var pickImageController: UIImagePickerController?

    // 闪光灯抖动函数
    let torchDebounce = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化硬件捕捉设备（音频或视频）
        let device = AVCaptureDevice.default(for: .video)
        if device?.hasTorch == true {
            self.device = device
        }
        pickImageController=UIImagePickerController.init()
        
        // 初始化闪光灯防抖监听
        torchDebounce.asDriverOnErrorJustComplete()
            .debounce(.seconds(1)).drive(onNext: { [weak self] _ in
                self?.device?.torchMode = .off
                self?.device?.unlockForConfiguration()
            }).disposed(by: rx.disposeBag)
        
        // 初始化音频播放
        var bundlePath = Bundle.main.path(forResource: "voice", ofType: "mp3")!
        let url = URL(fileURLWithPath: bundlePath)
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error loading audio Player")
        }
    }

    override func makeUI() {
        super.makeUI()
        languageChanged.subscribe(onNext: { [weak self] () in
            self?.navigationTitle = R.string.localizable.homeTabBarHomeTitle.key.localized()
        }).disposed(by: rx.disposeBag)
         tableView.register(R.nib.homeCell)
        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? HomeViewModel else { return }

        let input = HomeViewModel.Input(selection: tableView.rx.modelSelected(HomeSectionItem.self).asDriver())
        let output = viewModel.transform(input: input)

        let dataSource = RxTableViewSectionedReloadDataSource<HomeSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .notificationItem(let viewModel),
                .flashItem(let viewModel),
                .vibrationItem(let viewModel),
                .voiceItem(let viewModel),
                .settingsItem(let viewModel),
                .cameraItem(let viewModel),
                .albumItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? HomeCell)!
                cell.bind(to: viewModel)
                return cell
            }
        })

        output.items.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)

        output.selectedEvent.drive(onNext: { [weak self] (item) in
            switch item {
            case .notificationItem:
                // 1.设置触发条件
                let timeTrigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.5, repeats: false)
                // 2.创建通知内容
                let content = UNMutableNotificationContent.init()
                content.badge = NSNumber(value: (UIApplication.shared.applicationIconBadgeNumber + 1))
                content.sound = UNNotificationSound.default
                content.body = "海豚架构平台生态圈"
                content.subtitle = "foobar"
                // 传递用户扩展数据
                let detail = "这是一条测试数据"
                let userInfo = ["detail": detail]
                content.userInfo = userInfo
                // 通过下拉通知显示附件
                do {
                    let imageURL = Bundle.main.url(forResource: "2048", withExtension: "jpeg")!
                    let imageAttachment = try UNNotificationAttachment(identifier: "iamgeAttachment", url: imageURL, options: nil)
                    content.attachments = [imageAttachment]
                } catch {
                   print(error.localizedDescription)
                }
                // 3.通知标识
                let requestIdentifier = NSString.init(format: "%lf", NSDate().timeIntervalSince1970)
                // 4.创建通知请求
                let request = UNNotificationRequest(identifier: requestIdentifier as String, content: content, trigger: timeTrigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                    if error == nil {
                        print("推送成功")
                    }
                })
            case .flashItem:
                guard let device = self?.device else {
                    self?.tableView.makeToast("没有安装手电筒", position: .bottom, image: R.image.icon_toast_warning())
                    return
                }
                guard device.isTorchAvailable else {
                    self?.tableView.makeToast("手电筒目前不可用", position: .bottom, image: R.image.icon_toast_warning())
                    return
                }
                do {
                    try device.lockForConfiguration()
                } catch {
                    self?.tableView.makeToast("访问手电筒出错", position: .bottom, image: R.image.icon_toast_warning())
                }
                try? device.setTorchModeOn(level: Float(1))
                self?.torchDebounce.onNext(Void())
            case .vibrationItem:
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.prepare()
                generator.impactOccurred()
            case .voiceItem:
                if let audioPlayer = self?.audioPlayer, audioPlayer.duration > 0.0 {
                    audioPlayer.play()
                }
            case .settingsItem:var pickImageController: UIImagePickerController?
                if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { success in
                        print("跳转成功", success)
                    })
                }
            case .cameraItem:
                let authStatus = PHPhotoLibrary.authorizationStatus()
                if authStatus == .notDetermined {
                    // 用户尚未授权
                    PHPhotoLibrary.requestAuthorization({ [weak self] (states) in
                        guard let strongSelf = self else { return }
                        if states == .authorized {
                            strongSelf.openCamera()
                        }
                    })
                } else if authStatus == .authorized {
                    // 可以访问 去打开摄像机
                    self?.openCamera()
                } else if authStatus == .restricted || authStatus == .denied {
                    // App无权访问摄像机 用户已明确拒绝
                    self?.tableView.makeToast("无法访问系统摄像机你已经拒绝授权", position: .bottom, image: R.image.icon_toast_warning())
                }
            case .albumItem:
                let authStatus = PHPhotoLibrary.authorizationStatus()
                if authStatus == .notDetermined {
                    //用户尚未授权
                    PHPhotoLibrary.requestAuthorization({ [weak self] (states) in
                        guard let strongSelf = self else { return }
                        if states == .authorized {
                            strongSelf.openPhoto()
                        }
                    })
                } else if authStatus == .authorized {
                    // 可以访问 去打开相册
                    self?.openPhoto()
                } else if authStatus == .restricted || authStatus == .denied {
                    // App无权访问照片库 用户已明确拒绝
                    self?.tableView.makeToast("无法访问系统相册你已经拒绝授权", position: .bottom, image: R.image.icon_toast_warning())
                }
            }
        }).disposed(by: rx.disposeBag)
    }
    
    // 打开相机
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.sourceType = .camera
                picker.cameraFlashMode = .on
                self.present(picker, animated: true, completion: nil)
            }
        }
    }
    
    // 打开相册
    func openPhoto() {
       if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
           DispatchQueue.main.async {
               let picker = UIImagePickerController()
               picker.sourceType = .photoLibrary
               self.present(picker, animated: true)
           }
       }
    }
 
}
