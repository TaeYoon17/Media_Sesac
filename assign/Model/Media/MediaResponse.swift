//
//  MovieResponse.swift
//  assign
//
//  Created by 김태윤 on 2023/08/12.
//

import Foundation
import SwiftyJSON
struct MediaResponse:Codable{
    let page:Int
    private let _results: [RawResult]
    var results: [any Media]{
        _results.map { rawResult in
            guard let da = try? JSONEncoder().encode(rawResult) else {fatalError("바꾸기 실패")}
            let dec = JSONDecoder()
            switch rawResult.mediaType{
            case .movie:
                if let movie:Movie = try? dec.decode(Movie.self, from: da){ return movie }
            case .tv:
                if let tv:TV = try? dec.decode(TV.self, from: da){ return tv }
            case .all:break
            }
            fatalError("여기 문제요")
        }
    }
    let totalPages:Int
    let totalResults:Int
    //MARK: -- Legacy
    //    init(json:JSON){
    //        self.page = json["page"].intValue
    //        self.totalPages = json["total_pages"].intValue
    //        self.totalResults = json["total_results"].intValue
    //        self.results = json["results"].arrayValue.map{ element in
    //            let elementType = TMDB.MediaType(rawValue: element["media_type"].stringValue) ?? .all
    //            switch elementType{
    //            case .all: fatalError("타입 변환에 문제")
    //            case .movie: return Movie(json: element)
    //            case .tv: return TV(json: element)
    //            }
    //        }
    //    }
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case _results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
struct RawResult: Codable,Media {
    var called: String{ self.title ?? self.name ?? "called not found" }
    var originalCalled: String{
        self.originalTitle ?? self.originalName ?? "originalCalled not found"
    }
    var publishDate: String{
        self.releaseDate ?? firstAirDate ?? "publishDate not found"
    }
    
    var adult: Bool
    var backdropPath: String?
    var mediaID: Int
    var title: String?
    var originalLanguage: String
    var originalTitle: String?
    var overview: String
    var posterPath: String?
    var mediaType: TMDB.MediaType
    var genreIDS: [Int]
    var popularity: Double
    var releaseDate: String?
    var video: Bool?
    var voteAverage: Double
    var voteCount: Int
    var name, originalName, firstAirDate: String?
    var originCountry: [String]?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case mediaID = "id", title
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case name
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
    }
}
