//
//  OnboardingVC+FirstVC.swift
//  assign
//
//  Created by 김태윤 on 2023/08/27.
//

import UIKit
import SnapKit
extension OnboardingVC{
    class FirstVC:UIViewController{
        @DefaultsState(\.isNotFirst) var isNotFirst
        lazy var loginBtn = {
            let btn = UIButton()
            var config = UIButton.Configuration.filled()
            config.title = "오키도키요"
            btn.configuration = config
            btn.addAction(.init(handler: {_ in
                print("탭탭탭")
                self.isNotFirst.toggle()
            }), for: .touchUpInside)
            return btn
        }()
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .systemGreen
            view.addSubview(loginBtn)
            loginBtn.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(20)
                make.horizontalEdges.equalToSuperview().inset(60)
            }
        }
    }
}
