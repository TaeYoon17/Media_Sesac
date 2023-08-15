//
//  Cache.swift
//  assign
//
//  Created by 김태윤 on 2023/08/14.
//

import Foundation
class Cache{ // 램에서 노는 친구
    typealias T_Window = TMDB.Time_Window
    typealias M_Type = TMDB.MediaType
    static let shared:Cache = Cache()
//    var week = "2022년 8월 22일"
    var timeType: TMDB.Time_Window{
        didSet{ UserDefaults.standard.timeType = timeType }
    }
    var mediaType: TMDB.MediaType{
        didSet{ UserDefaults.standard.mediaType = mediaType }
    }
    private var trendMedias:[Two<T_Window,M_Type>:[any Media]] = [:]{
        didSet{
            guard let trendFetchCompletion,
                  let data = trendMedias[Two(values: (timeType,mediaType))],
            trendMedias.count != T_Window.allCases.count * M_Type.allCases.count
            else {return}
            trendFetchCompletion(data)
        }
    }
    var trendFetchCompletion:(([any Media])->Void)?
    var getMediaList:[any Media]?{
//        여기에서 날짜 확인하고 업데이트 해야한다.
        self.trendMedias[Two(values: (timeType,mediaType))]
    }
    private init(){
        if let timeType = UserDefaults.standard.timeType{
            self.timeType = timeType
        }else{
            self.timeType = .day
            UserDefaults.standard.timeType = .day
        }
        if let mediaType = UserDefaults.standard.mediaType{
            self.mediaType = mediaType
        }else{
            self.mediaType = .all
            UserDefaults.standard.mediaType = .all
        }
        initTrends()
    }
    
}
extension Cache{
    private func initTrends(){
        let userDefaults = UserDefaults.standard
        let nowDay = Date()
        let nowWeek = nowDay.getWeek
        let saveTrends: (Two<T_Window,M_Type>) -> Void = { val in
            let (t,m) = val.values
//            TMDB.Router.Trend(media: m, date:t).action { json in
//                let data = TrendResponse(json: json).results
//                self.trendMedias[val] = data
//                userDefaults.setTrend(media: m, time: t, data: data)
//            }
            TMDB.Router.Trend(media: m, date: t).action{ (res:TrendResponse) in
                self.trendMedias[val] = res.results
                userDefaults.setTrend(media: m, time: t, data: res.results)
            }
        }
        self.trendMedias = [:]
        T_Window.allCases.forEach { t in M_Type.allCases.forEach { m in
            let two = Two(values: (t, m))
            switch t{
            case .day:
                if let lastDay = userDefaults.lastDay, lastDay == nowDay{
                    trendMedias[two] = userDefaults.getTrend(media: m, time: t)
                }else{
                    saveTrends(two)
                }
            case .week:
                if let lastWeek = userDefaults.lastWeek, let nowWeek, nowWeek == lastWeek{
                    trendMedias[two] = userDefaults.getTrend(media: m, time: t)
                }else{
                    saveTrends(two)
                }
            }
        } }
    }
    func updateTrends(){ }
}
fileprivate struct Two<T:Hashable,U:Hashable> : Hashable {
    let values : (T, U)
    var hashValue : Int {
        get {
            let (a,b) = values
            return a.hashValue &* 31 &+ b.hashValue
        }
    }
}
fileprivate func ==<T:Hashable,U:Hashable>(lhs: Two<T,U>, rhs: Two<T,U>) -> Bool {
    return lhs.values == rhs.values
}
