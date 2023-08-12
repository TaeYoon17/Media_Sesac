//
//  UserDefaultsHelper.swift
//  assign
//
//  Created by 김태윤 on 2023/08/12.
//

import Foundation
import SwiftyJSON
extension UserDefaults{
//    typealias ElementType = (TMDB.MediaType,Data)
    struct MediaElement:Codable{
        let type: TMDB.MediaType
        let data:Data
    }
    func getTrend(media: TMDB.MediaType,time: TMDB.Time_Window)-> [Media]?{
        let decoder = JSONDecoder()
        guard let rawData = self.data(forKey: "\(media.rawValue)\(time.rawValue)") else { return nil }
        switch media{
        case .all:
            guard let rawMediaList = try? decoder.decode([MediaElement].self, from: rawData) else {
                return nil
            }
            let mediaList:[Media] = rawMediaList.compactMap { element in
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
            let type = [Movie.self]
            guard let dataDecoded = try? decoder.decode([Movie].self, from: rawData) else { return nil }
            return dataDecoded
        case .tv:
            guard let dataDecoded = try? decoder.decode([TV].self, from: rawData) else{ return nil }
            return dataDecoded
        }
    }
    func setTrend(media: TMDB.MediaType,time: TMDB.Time_Window,data:[Media]){
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
            print(#function,"변환 성공")
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
