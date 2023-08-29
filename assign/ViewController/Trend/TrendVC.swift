//
//  MainVC.swift
//  assign
//
//  Created by 김태윤 on 2023/08/11.
//

import Foundation
import UIKit
class TrendVC: UIViewController{
// 모델 뷰 바인딩
    let globalCache = Cache.shared
    lazy var mediaType:TMDB.MediaType = globalCache.mediaType{
        didSet{
            guard mediaType != oldValue else {return}
            globalCache.mediaType = mediaType
            mediaList = globalCache.getMediaList
    
        }
    }
    lazy var timeType:TMDB.Time_Window = globalCache.timeType{
        didSet{
            guard timeType != oldValue else {return}
            globalCache.timeType = timeType
            mediaList = globalCache.getMediaList
            self.navigationItem.title = navTitle
            self.configureDateLabel()
        }
    }
    lazy var mediaList = Cache.shared.getMediaList{
        didSet{
            guard mediaList != nil else {return}
            print("medialist 가져오기 성공")
            self.tableView.reloadData()
        }
    }
    let timeKoreanTable = [TMDB.Time_Window.day: "일별",.week:"주간"]
    var navTitle:String{
        "\(timeKoreanTable[timeType] ?? "") 트렌드"
    }
    
    @IBOutlet var dateTypeBtns: [UIButton]!
    @IBOutlet var trendSegmentControl: [UISegmentedControl]!
    @IBOutlet var dateLabels: [UILabel]!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var mediaSegmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        print(#function)
        super.viewDidLoad()
        configure()
        globalCache.trendFetchCompletion = {[weak self] list in
            print("컴플리션 실행! \(list)")
            self?.mediaList = list
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        self.navigationItem.title = navTitle
        self.navigationController?.insertAccount()
        self.scrollViewDidScroll(self.tableView)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.deleteAccount()
    }
    var prevY: CGFloat = 0.0
    let lineY:CGFloat = -143
    func configure(){
        self.navigationItem.title = navTitle
        self.configureDateLabel()
        self.configureTableView()
        self.configureBlur()
        self.configureCalenderBtn()
        self.configureSegmentController()
    }
    func configureDateLabel(){
        self.dateLabels.forEach {
            switch timeType{
            case .day:
                $0.text = Date().day
            case .week:
                $0.text = Date().getWeek ?? "알려진 정보가 없습니다."
            }
        }
    }
}

extension TrendVC:UITableViewDelegate,UITableViewDataSource{
    func configureTableView(){
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = {
            let uiview = UIView(frame: .init(x: 0, y: 0, width: view.bounds.width, height: 64))
            uiview.backgroundColor = .white
            return uiview
        }()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(.init(nibName: TrendItemCell.identifier, bundle: nil), forCellReuseIdentifier: TrendItemCell.identifier)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.mediaList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let c = tableView.dequeueReusableCell(withIdentifier: TrendItemCell.identifier)
                as? TrendItemCell else {return .init()}
        c.selectionStyle = .none
        if let media = self.mediaList?[indexPath.row]{
            c.media = media
            c.clipBtnAction = .init(handler: { _ in
                print("링크가 눌림!!")
            })
        }
        return c
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let mediaItem = mediaList?[indexPath.row], let mediaType = mediaItem.mediaType else { return }
        TMDB.Router.Credit(media: mediaType, id: mediaItem.mediaID)
            .action { (res:CreditResponse) in
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: MediaInfoVC.identifier) as? MediaInfoVC else {return}
//                vc.res.cast
                vc.cast = res.cast
                vc.crew = res.crew
                vc.media = mediaItem
//                vc.navigationItem.backBarButtonItem?.title = ""
                self.navigationController?.navigationBar.topItem?.title = ""
                self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        print("선택됨!! \(indexPath.row)")
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let nowY = scrollView.contentOffset.y
        if prevY <= lineY && nowY > lineY{
            DispatchQueue.main.async{
                self.headerView.isHidden = false
            }
        }else if prevY < lineY{
            DispatchQueue.main.async {
                self.headerView.isHidden = true
            }
        }
        self.navigationController?.scrollAccountView(nowY: nowY)
        print(nowY)
        let maxHeight = scrollView.contentSize.height - 100
//        print(maxHeight,nowY + self.bottomView.frame.origin.y)
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else {return}
            if maxHeight <= nowY + self.bottomView.frame.origin.y{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.bottomView.layer.opacity = 1
                    self.bottomView.isHidden = false
                }
            }else if prevY <= lineY{
                    self.bottomView.layer.opacity = 1
                    self.bottomView.isHidden = false
            }else if prevY < nowY{
                self.bottomView.layer.opacity = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.bottomView.isHidden = true
                }
            }else if prevY > nowY{
            self.bottomView.layer.opacity = 1
            self.bottomView.isHidden = false
        }
    }
        prevY = nowY
    }
}


//MARK: -- Networking
//        let data = UserDefaults.standard.getTrend(media: .all, time: .day) as?
//        TMDB.Router.Trend(media: .all, date: .week).action { json in
//            let res = TrendResponse(json: json)
//            UserDefaults.standard.setTrend(media: .all, time: .week, data: res.results)
//        } failHandler: { err in
//            print(err)
//        }
//        let data = UserDefaults.standard.getTrend(media: .all, time: .week)
//        print(data)
