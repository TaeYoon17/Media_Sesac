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
            DispatchQueue.main.async { trendFetchCompletion(data) }
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
        let nowDay = Date().day
        let nowWeek = Date().getWeek
        let saveTrends: (Two<T_Window,M_Type>) -> Void = { val in
            let (t,m) = val.values
            TMDB.Router.Trend(media: m, date: t).action(queue: .global()){ (res:MediaResponse) in
                self.trendMedias[val] = res.results
                userDefaults.setTrend(media: m, time: t, data: res.results)
            }
        }
        self.trendMedias = [:]
        //MARK: -- 처음에 API 불리는 곳
        DispatchQueue.global().async {
            T_Window.allCases.forEach { t in M_Type.allCases.forEach { m in
                let two = Two(values: (t, m))
                switch t{
                case .day:
                    if let lastDay = userDefaults.lastDay, lastDay == nowDay,
                       let media = userDefaults.getTrend(media: m, time: t){
                        self.trendMedias[two] = media
                    }else{
                        print("API_Router Called - day")
                        saveTrends(two)
                        userDefaults.lastDay = nowDay
                    }
                case .week:
                    if let lastWeek = userDefaults.lastWeek, let nowWeek, nowWeek == lastWeek
                        ,let media = userDefaults.getTrend(media: m, time: t){
                        self.trendMedias[two] = media
                    }else{
                        print("API_Router Called - week")
                        saveTrends(two)
                        userDefaults.lastWeek = nowWeek
                    }
                }
            }
            }
        }
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
