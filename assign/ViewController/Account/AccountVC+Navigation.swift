//
//  AccountVC+Navigation.swift
//  assign
//
//  Created by 김태윤 on 2023/09/01.
//

import UIKit
//MARK -- AccountVC 네비게이션 설정
extension AccountVC{
    func initNavigation(){
        self.navigationItem.title = "계정"
        self.navigationItem.rightBarButtonItem = .init(title: "완료", style: .done, target: self, action: #selector(Self.rightBtnTapped(_:)))
        self.navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .cancel, target: self, action: #selector(Self.leftBtnTapped(_:)))
    }
    @objc func rightBtnTapped(_ sender:UIBarButtonItem){
        print(#function)
        AppManager.shared.accountImage = profileImage
        self.dismiss(animated: true)
    }
    @objc func leftBtnTapped(_ sender: UIBarButtonItem){
        self.dismiss(animated: true)
    }
}

