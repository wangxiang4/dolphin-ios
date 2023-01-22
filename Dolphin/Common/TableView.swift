//
//  表格视图rx-ui数据绑定,初始化默认配置
//  Created by 福尔摩翔 on 2022/11/27.
//  Copyright © 2022 entfrm All rights reserved.
//
import SwiftUI

class TableView: UITableView {

    init () {
        super.init(frame: CGRect(), style: .grouped)
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    
    // 渲染ui与数据绑定
    func makeUI() {
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 50
        sectionHeaderHeight = 40
        backgroundColor = .clear
        cellLayoutMarginsFollowReadableWidth = false
        keyboardDismissMode = .onDrag
        separatorColor = .clear
        separatorInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: 0)
    
        let uiView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        uiView.snp.makeConstraints { (make) in make.height.equalTo(1) }
        tableHeaderView = uiView
        tableFooterView = UIView()
    }
}
