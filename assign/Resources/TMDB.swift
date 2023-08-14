//
//  TMDB.swift
//  assign
//
//  Created by 김태윤 on 2023/08/11.
//

import Foundation
import Alamofire
import SwiftyJSON
enum TMDB{
    enum MediaType:String,Codable,CaseIterable{
        case movie,tv,all
        func getGenre(id:Int)->String{
            Genre.getGenre(mediaType: self,id: id)
        }
        var idx:Int{
            switch self{
            case .all: return 2
            case .movie: return 0
            case .tv: return 1
            }
        }
    }
    enum Time_Window:String,CaseIterable{
        case day,week
    }
    enum LanguageCode: String{
        case en,kr,ja
    }
}
//MARK: -- 성별 관련 데이터
extension TMDB{
    enum Gender:Int{
        private static var koreanTable:[Gender:String] = [
            .not: "알려지지 않음",.male:"남성",.female:"여성",.non_binary:"안알랴줌"
        ]
        case not, male,female,non_binary
        var getKorean:String{
            Self.koreanTable[self] ?? "알려지지 않음"
        }
        func tableUpdate(){}
    }
}
//MARK: -- 장르 관련 데이터
extension TMDB{
    enum Genre{
        private static var movieGenreTable = [
            "Action":28,"Adventure":12,"Animation":16,"Comedy":35,"Crime":80,"Documentary":99,
            "Drama":18,"Family":10751,"Fantasy":14,"History":36,"Horror":27,"Music":10402,
            "Mystery":9648,"Romance":10749,"Science Fiction":878,"TV Movie":10770,"Thriller":53,
            "War":10752,"Western":37].reduce(into:[:]) { p, d in p[d.value] = d.key }
        private static var tvGenreTable = [
            "Action & Adventure":10759,"Animation":16,"Comedy":35,"Crime":80,
            "Documentary":99,"Drama":18,"Family":10751,"Kids":10762,"Mystery":9648,
            "News":10763,"Reality":10764,"Sci-Fi & Fantasy":10765,"Soap":10766,
            "Talk":10767,"War & Politics":10768,"Western":37
        ].reduce(into:[:]){p,d in p[d.value] = d.key}
        static func getGenre(mediaType: MediaType,id: Int)->String{
            switch mediaType{
            case .movie:
                return Self.movieGenreTable[id] ?? "장르를 찾을 수 없습니다."
            case .tv:
                return Self.tvGenreTable[id] ?? "장르를 찾을 수 없습니다."
            default: return "장르를 찾을 수 없습니다."
            }
        }
    }
}
