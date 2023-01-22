//
//  基础表格列视图rx-ui数据绑定,初始化默认配置
//  Created by wangxiang4 on 2022/11/27.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import SwiftUI
import RxSwift
import RxCocoa

class TableViewCell: UITableViewCell {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    
    // 给每个列创建单独的垃圾袋,这里表格列是属性共享的不可见区域列会拿出来重用,会导致列事件点击无效,rx冲突无法销毁
    var cellDisposeBag = DisposeBag()
    
    // 渲染ui与数据绑定
    func makeUI() {
        layer.masksToBounds = true
        selectionStyle = .none
        backgroundColor = .clear
        theme.selectionColor = themeService.attribute { $0.primary }
        containerView.theme.backgroundColor = themeService.attribute { $0.primary }
        setNeedsDisplay()
    }
    
    // 选中时显示的颜色
    var selectionColor: UIColor? {
        didSet { setSelected(isSelected, animated: true) }
    }

    // 创建约束布局
    lazy var containerView: View = {
        let view = View()
        view.backgroundColor = .clear
        view.cornerRadius = Configs.BaseComponentDimensions.cornerRadius
        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(horizontal: self.inset, vertical: self.inset/2))
        })
        return view
    }()

    // 创建栈堆布局
    lazy var stackView: StackView = {
        let subviews: [UIView] = []
        let view = StackView(arrangedSubviews: subviews)
        view.axis = .horizontal
        view.alignment = .center
        self.containerView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(inset/2)
        })
        return view
    }()

    // 行选中事件
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundColor = selected ? selectionColor : .clear
    }

    // VC视图模型绑定
    func bind(to viewModel: TableViewCellViewModel) {
    }
}
