//
//  MediaInfoVC+Navigation.swift
//  assign
//
//  Created by 김태윤 on 2023/08/15.
//

import Foundation
extension MediaInfoVC{
    func configureaNaviagtion(){
        self.navigationItem.title = "출연/제작"
//        self.navigationItem.titleView?.tintColor = .black
        self.navigationItem.largeTitleDisplayMode = .never
//        self.navigationItem.titleView?.backgroundColor = .clear
//        self.navigationController?.navigationBar.scrollEdgeAppearance = .init()
        self.tabBarController?.tabBar.scrollEdgeAppearance = .init()
    }
}
