//
//  BaseVC.swift
//  assign
//
//  Created by 김태윤 on 2023/08/29.
//

import UIKit
import SnapKit

class BaseVC: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setConstraints()
    }
    func configureView(){ }
    func setConstraints(){ }
}
