//
//  Movie.swift
//  assign
//
//  Created by 김태윤 on 2023/08/11.
//

import Foundation
import SwiftyJSON
struct Movie:Media,Codable{
    //MARK: -- MediaProtocol
    var called: String {
        get{ title }
        set {title = newValue}
    }
    var originalCalled: String {
        get { originalTitle }
        set {originalTitle = newValue}
    }
    var publishDate: String {
        get {releaseDate}
        set {releaseDate = newValue}
    }
    var adult:Bool
    var backdropPath :String?
    var mediaID:Int
    var originalLanguage:String
    var overview:String
    var posterPath:String?
    var mediaType:TMDB.MediaType
    var genreIDS:[Int]
    var popularity:Double
    var voteAverage:Double
    var voteCount:Int
//MARK: -- Movie 독자 데이터
    var title:String
    var originalTitle :String
    var releaseDate:String
    var video: Bool
    
    init(json:JSON){
        self.adult = json["adult"].boolValue
        self.backdropPath = json["backdrop_path"].stringValue
        self.mediaID = json["id"].intValue
        self.title = json["title"].stringValue
        self.originalLanguage = json["original_language"].stringValue
        self.originalTitle = json["original_title"].stringValue
        self.overview = json["overview"].stringValue
        self.posterPath = json["poster_path"].stringValue
        self.mediaType = TMDB.MediaType(rawValue: json["media_type"].stringValue) ?? .all
        self.genreIDS = json["genre_ids"].arrayValue.map{$0.intValue}
        self.popularity = json["popularity"].doubleValue
        self.releaseDate = json["release_date"].stringValue // 여기 수정해야함
        self.video = json["video"].boolValue
        self.voteAverage = json["vote_average"].doubleValue
        self.voteCount = json["vote_count"].intValue
    }
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case mediaID = "id"
        case title
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
    }
}
