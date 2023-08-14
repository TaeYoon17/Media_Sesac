//
//  TV.swift
//  assign
//
//  Created by 김태윤 on 2023/08/12.
//

import Foundation
import SwiftyJSON

struct TV:Media,ConvertableJSON{
    //MARK: -- MediaProtocol
    var called: String {
        get{ name }
//        set { name = newValue }
    }
    var originalCalled: String {
        get { originalName }
//        set {originalName = newValue}
    }
    var publishDate: String {
        get { firstAirDate}
//        set { firstAirDate = newValue}
    }
    var adult:Bool
    var backdropPath :String
    var id:Int
    var originalLanguage:String
    var overview:String
    var posterPath:String
    var mediaType:TMDB.MediaType
    var genreIDS:[Int]
    var popularity:Double
    var voteAverage:Double
    var voteCount:Int
    
    var name:String
    var originalName :String
    var firstAirDate:String
    var originCountry: [String]
    
    init(json:JSON){
        self.adult = json["adult"].boolValue
        self.backdropPath = json["backdrop_path"].stringValue
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.originalLanguage = json["original_language"].stringValue
        self.originalName = json["original_name"].stringValue
        self.overview = json["overview"].stringValue
        self.posterPath = json["poster_path"].stringValue
        self.mediaType = TMDB.MediaType(rawValue: json["media_type"].stringValue) ?? .all
        self.genreIDS = json["genre_ids"].arrayValue.map{$0.intValue}
        self.popularity = json["popularity"].doubleValue
        self.firstAirDate = json["first_air_date"].stringValue // 여기 수정해야함
        self.originCountry = json["origin_country"].arrayValue.map{$0.stringValue}
        self.voteAverage = json["vote_average"].doubleValue
        self.voteCount = json["vote_count"].intValue
    }
//    init(
//        adult:Bool,
//        backdropPath :String,
//        id:Int,
//        title:String,
//        originalLanguage:String,
//        originalTitle :String,
//        overview:String,
//        posterPath:String,
//        mediaType:TMDB.MediaType,
//        genreIDS:[Int],
//        popularity:Double,
//        releaseDate:String,
//        video: Bool,
//        voteAverage:Double,
//        voteCount:Int
//    ){
//        self.adult = adult
//        self.backdropPath = backdropPath
//    }
}
