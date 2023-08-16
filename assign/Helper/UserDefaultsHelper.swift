//
//  UserDefaultsHelper.swift
//  assign
//
//  Created by 김태윤 on 2023/08/12.
//

import Foundation
import SwiftyJSON
//MARK: -- 트렌드 미디어 리스트
extension UserDefaults{
    struct MediaElement:Codable{
        let type: TMDB.MediaType
        let data:Data
    }
    func getTrend(media: TMDB.MediaType,time: TMDB.Time_Window)-> [any Media]?{
        let decoder = JSONDecoder()
        guard let rawData = self.data(forKey: "\(media.rawValue)\(time.rawValue)") else { return nil }
        switch media{
        case .all:
            guard let rawMediaList = try? decoder.decode([MediaElement].self, from: rawData) else {
                return nil
            }
            let mediaList:[any Media] = rawMediaList.compactMap { element in
                switch element.type{
                case .movie:
                    guard let media = try? decoder.decode(Movie.self, from:element.data) else {return nil}
                    return media
                case .tv:
                    guard let media = try? decoder.decode(TV.self, from: element.data) else {return nil}
                    return media
                case .all: fatalError("바뀌면 안된다고")
                }
            }
            return mediaList
        case .movie:
            guard let dataDecoded = try? decoder.decode([Movie].self, from: rawData) else { return nil }
            return dataDecoded
        case .tv:
            guard let dataDecoded = try? decoder.decode([TV].self, from: rawData) else{ return nil }
            return dataDecoded
        }
    }
    func setTrend(media: TMDB.MediaType,time: TMDB.Time_Window,data:[any Media]){
        switch media{
        case .all:
            let mediaList:[MediaElement] = data.compactMap { media in
                guard let encoded = try? JSONEncoder().encode(media) else {return nil}
                return .init(type: media.mediaType, data: encoded)
            }
            guard let encoded = try? JSONEncoder().encode(mediaList) else{
                print(#function,"인코딩 실패")
                return
            }
//            print(#function,"변환 성공")
            self.setValue(encoded, forKey: "\(media.rawValue)\(time.rawValue)")
        case .movie:
            guard let casting = data as? [Movie],let encoded = try? JSONEncoder().encode(casting) else {
                print(#function,"인코딩 실패")
                return
            }
            self.setValue(encoded, forKey: "\(media.rawValue)\(time.rawValue)")
        case .tv:
            guard let casting = data as? [TV],let encoded = try? JSONEncoder().encode(casting) else {
                print(#function,"인코딩 실패")
                return
            }
            self.setValue(encoded, forKey: "\(media.rawValue)\(time.rawValue)")
        }
    }
}
//MARK: --  현재 트렌드 미디어 타입
extension UserDefaults{
    var mediaType: TMDB.MediaType?{
        get{
            guard let str = self.string(forKey: "mediaType") else {return nil}
            return TMDB.MediaType(rawValue: str)
        }
        set{
            guard let newValue,let mediaType, newValue != mediaType else {return}
            self.set(newValue.rawValue, forKey: "mediaType")
        }
    }
}
//MARK: -- 트렌드 시간 타입
extension UserDefaults{
    var timeType: TMDB.Time_Window?{
        get{
            guard let str = self.string(forKey: "timeType") else {return nil}
            return TMDB.Time_Window(rawValue: str)
        }
        set{
            guard let newValue,let timeType, newValue != timeType else {return}
            self.set(newValue.rawValue, forKey: "timeType")
        }
    }
}
//MARK: -- 마지막에 저장한 날짜
extension UserDefaults{
    var lastDay:String?{
        get{
            return self.string(forKey: "day")
        }
        set{
            guard let newValue else { return }
            self.set(newValue, forKey: "day")
        }
    }
}
//MARK: -- 저장된 주
extension UserDefaults{
    var lastWeek:String?{
        get{
            return self.string(forKey: "week")
        }
        set{
            guard let newValue else {return}
            self.set(newValue, forKey: "week")
        }
    }
}


