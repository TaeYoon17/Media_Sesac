//
//  MediaInfoVC+Navigation.swift
//  assign
//
//  Created by 김태윤 on 2023/08/15.
//

import Foundation
import UIKit
extension MediaInfoVC{
    func configureaNaviagtion(){
        self.navigationItem.title = "출연/제작"
//        self.navigationItem.titleView?.tintColor = .black
        self.navigationItem.largeTitleDisplayMode = .never
//        self.navigationItem.titleView?.backgroundColor = .clear
        self.navigationController?.navigationBar.scrollEdgeAppearance = .init()
        self.tabBarController?.tabBar.scrollEdgeAppearance = .init()
        self.popBtn.addTarget(self, action: #selector(Self.backBtnTapped), for: .touchUpInside)
    }
    @objc func backBtnTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    @MainActor
    func scrollNavigation(nowY: CGFloat){
        let targetHeight:CGFloat = self.backImgView.bounds.height / 2
        let normTarget:CGFloat = 44
        var norm = (nowY - targetHeight) / normTarget + 1
        norm = max(0,norm,min(1,norm))
        self.popBtn.layer.opacity = 1 - Float(norm)
        if nowY > targetHeight {
            self.popBtn.isHidden = true
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }else{
            self.popBtn.isHidden = false
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollNavigation(nowY: scrollView.contentOffset.y)
    }
}
