//
//  MainVC+ViewConfig.swift
//  assign
//
//  Created by 김태윤 on 2023/08/14.
//

import Foundation
import UIKit
//MARK: -- 블러 설정
extension TrendVC{
    func configureBlur(){
        DispatchQueue.main.async {
            self.headerView.getBlur(style: .prominent, corderRadius: 0)
            self.headerView.backgroundColor = .init(white: 1, alpha: 0.666)
            self.tableHeaderView.backgroundColor = .white
        }
    }
}


//MARK: -- 주,일 버튼 설정
extension TrendVC{
    func configureCalenderBtn(){
        self.dateTypeBtns.forEach {
            $0.showsMenuAsPrimaryAction = true
            let daily = UIAction(title:"일별 트렌드",image: .init(systemName: "1.circle"),handler: {[weak self] _ in
                self?.timeType = .day
                print("일간 확인")
            })
            let week = UIAction(title:"주간 트렌드",image:.init(systemName: "7.circle")){[weak self] _ in
                print("주간 확인")
                self?.timeType = .week
            }
            $0.menu = UIMenu(title: "설정하기",options: .displayInline,children: [daily,week])
        }
    }
}
//MARK: -- 세그먼트컨트롤러 설정
extension TrendVC{
    func configureSegmentController(){
        self.mediaSegmentControl.selectedSegmentIndex = self.mediaType.idx
        self.mediaSegmentControl.getBlur(style: .prominent)
        self.mediaSegmentControl.backgroundColor = .init(white: 1, alpha: 0.666)
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemBlue,
            .font: UIFont.systemFont(ofSize: 17)
        ]
        self.mediaSegmentControl.addTarget(self, action: #selector(Self.segmentControlChanged(_:)), for: .valueChanged)
        mediaSegmentControl.setTitleTextAttributes(
            selectedTextAttributes, for: .selected)
    }
    @objc func segmentControlChanged(_ sender: UISegmentedControl){
        self.mediaType = TMDB.MediaType.allCases[sender.selectedSegmentIndex]
        print(sender.selectedSegmentIndex)
        print(self.mediaType)
    }
}
