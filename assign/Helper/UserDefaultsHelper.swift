//
//  UserDefaultsHelper.swift
//  assign
//
//  Created by 김태윤 on 2023/08/12.
//

import Foundation
import SwiftyJSON
import UIKit
//MARK: -- 값 변화를 옵저빙하는 객체를 만듦
@propertyWrapper
struct DefaultsState<Value>{
    private var path: ReferenceWritableKeyPath<UserDefaults,Value>
    var wrappedValue: Value{
        get{ UserDefaults.standard[keyPath: path] }
        set{ UserDefaults.standard[keyPath: path] = newValue }
    }
    init(_ location:ReferenceWritableKeyPath<UserDefaults,Value>){
        self.path = location
    }
    var publisher:NSObject.KeyValueObservingPublisher<UserDefaults, Value>{
        UserDefaults.standard.publisher(for: path)
    }
}
//MARK: -- 트렌드 미디어 리스트
extension UserDefaults{
///  UserDefaults에 Encoding, Decoding을 위한 임시 객체
///  미디어 타입을 갖고 Data 타입으로 저장된 원래의 데이터를 갖고 있음
    struct MediaElement:Codable{
        let type: TMDB.MediaType
        let data:Data
    }
    func getTrend(media: TMDB.MediaType,time: TMDB.Time_Window) -> [any Media]?{
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
                guard let encoded = try? JSONEncoder().encode(media),let media = media.mediaType else {return nil}
                return .init(type: media, data: encoded)
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
    var mediaType: TMDB.MediaType{
        get{
            guard let str = self.string(forKey: "mediaType") else {return .all}
            return TMDB.MediaType(rawValue: str) ?? .all
        }
        set{
            guard newValue != mediaType else {return}
            self.set(newValue.rawValue, forKey: "mediaType")
        }
    }
}

//MARK: -- 트렌드 시간 타입
extension UserDefaults{
    var timeType: TMDB.Time_Window{
        get{
            guard let str = self.string(forKey: "timeType") else {return .day}
            return TMDB.Time_Window(rawValue: str) ?? .day
        }
        set{
            guard newValue != timeType else {return}
            self.set(newValue.rawValue, forKey: "timeType")
        }
    }
}
//MARK: -- 마지막에 저장한 날짜
extension UserDefaults{
    var lastDay:String?{
        get{ string(forKey: "day") }
        set{
            guard let newValue else { return }
            self.set(newValue, forKey: "day")
        }
    }
}
//MARK: -- 저장된 주
extension UserDefaults{
    var lastWeek:String?{
        get{ string(forKey: "week") }
        set{
            guard let newValue else {return}
            self.set(newValue, forKey: "week")
        }
    }
}
// MARK: -- 첫 방문 선택
extension UserDefaults{
    @objc var isNotFirst:Bool{
        get{ bool(forKey: "isNotFirst") }
        set{
            self.set(newValue, forKey: "isNotFirst")
        }
    }
}
//MARK: --  계정 이미지 defaults
extension UserDefaults{
    var profileImage: UIImage?{
        get{
            guard let data = self.data(forKey: "profileImage") else {return UIImage(systemName: "person.circle")}
            return UIImage(data: data) ?? UIImage(systemName: "person.circle")
        }
        set{
            guard let newValue else {return}
            let data = newValue.jpegData(compressionQuality: 0.6)
            self.set(data,forKey: "profileImage")
        }
    }
}
