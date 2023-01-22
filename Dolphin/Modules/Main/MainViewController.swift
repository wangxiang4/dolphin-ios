//
//  MainViewController.swift
//  KanglaiCall
//
//  Created by 福尔摩翔 on 2022/12/9.
//  Copyright © 2022 entfrm-wangxiang. All rights reserved.
//

import SwiftUI
import Kingfisher
class MainViewController: UIViewController {
    
    @IBOutlet weak var resultImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.path(forResource: "main", ofType: "gif")
        let url = URL(fileURLWithPath: path!)
        let provider = LocalFileImageDataProvider(fileURL: url)
        resultImage.kf.setImage(with: provider)
    }
}
