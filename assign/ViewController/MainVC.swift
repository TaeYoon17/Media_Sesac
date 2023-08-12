//
//  MainVC.swift
//  assign
//
//  Created by 김태윤 on 2023/08/11.
//

import Foundation
import UIKit
class MainVC: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
//        let data = UserDefaults.standard.getTrend(media: .all, time: .day) as?
//        TMDB.Router.Trend(media: .all, date: .week).action { json in
//            let res = TrendResponse(json: json)
//            UserDefaults.standard.setTrend(media: .all, time: .week, data: res.results)
//        } failHandler: { err in
//            print(err)
//        }
        let data = UserDefaults.standard.getTrend(media: .all, time: .week)
        print(data)
    }
}
