//
//  MainVC.swift
//  assign
//
//  Created by 김태윤 on 2023/08/11.
//

import Foundation
import UIKit
class MainVC: UIViewController{
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var calenderBtn: UIButton!
    @IBOutlet weak var mediaSegmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.headerView.getBlur(style: .prominent, corderRadius: 0)
            self.headerView.backgroundColor = .init(white: 1, alpha: 0.666)
            self.tableHeaderView.backgroundColor = .white
        }
        let uiview = UIView(frame: .init(x: 0, y: 0, width: view.bounds.width, height: 64))
        uiview.backgroundColor = .white
        tableView.tableFooterView = uiview
        configureTableView()
        configureCalenderBtn()
        configureSegmentController()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerView.backgroundColor = .clear
    }
    var prevY: CGFloat = 0.0
    let lineY:CGFloat = -143
    
}

extension MainVC:UITableViewDelegate,UITableViewDataSource{
    func configureTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = 80
        self.tableView.register(.init(nibName: MainItemCell.identifier, bundle: nil), forCellReuseIdentifier: MainItemCell.identifier)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let c = tableView.dequeueReusableCell(withIdentifier: MainItemCell.identifier) as? MainItemCell else {return .init()}
        c.backgroundColor = .red
        return c
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let nowY = scrollView.contentOffset.y
        print(nowY)
        if prevY <= lineY && nowY > lineY{
            DispatchQueue.main.async{
                self.headerView.isHidden = false
            }
        }else if prevY < lineY{
            DispatchQueue.main.async {
                self.headerView.isHidden = true
//                self.tableHeaderView.backgroundColor = .white
            }
        }
//        else if nowY == lineY{
//            DispatchQueue.main.async {
//                self.headerView.isHidden = true
//            }
//        }
        prevY = nowY
    }
}
//MARK: -- 주,일 버튼 설정
extension MainVC{
    func configureCalenderBtn(){
        self.calenderBtn.showsMenuAsPrimaryAction = true
        let daily = UIAction(title:"일별 트렌드",image: .init(systemName: "1.circle"),handler: { _ in
            print("일간 확인")
        })
        let week = UIAction(title:"주간 트렌드",image:.init(systemName: "7.circle")){ _ in
            print("주간 확인")
        }
        self.calenderBtn.menu = UIMenu(title: "설정하기",options: .displayInline,children: [daily,week])
        
        
    }
}
//MARK: -- 세그먼트컨트롤러 설정
extension MainVC{
    func configureSegmentController(){
        self.mediaSegmentControl.getBlur(style: .prominent)
        self.mediaSegmentControl.backgroundColor = .init(white: 1, alpha: 0.666)
        
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemBlue,
            .font: UIFont.systemFont(ofSize: 17)
        ]
        mediaSegmentControl.setTitleTextAttributes(
            selectedTextAttributes, for: .selected)
    }
}

//MARK: -- Networkign
//        let data = UserDefaults.standard.getTrend(media: .all, time: .day) as?
//        TMDB.Router.Trend(media: .all, date: .week).action { json in
//            let res = TrendResponse(json: json)
//            UserDefaults.standard.setTrend(media: .all, time: .week, data: res.results)
//        } failHandler: { err in
//            print(err)
//        }
//        let data = UserDefaults.standard.getTrend(media: .all, time: .week)
//        print(data)
