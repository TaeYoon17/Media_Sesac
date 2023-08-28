//
//  BaseView.swift
//  assign
//
//  Created by 김태윤 on 2023/08/28.
//

import UIKit
import SnapKit
class BaseView:UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("이건 안돼용~")
    }
    func configureView(){
        
    }
    func setConstraints(){
        
    }
}
