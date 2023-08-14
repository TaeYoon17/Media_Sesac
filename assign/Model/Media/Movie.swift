//
//  Movie.swift
//  assign
//
//  Created by 김태윤 on 2023/08/11.
//

import Foundation
import SwiftyJSON
struct Movie:Media,ConvertableJSON{
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
//MARK: -- Movie 독자 데이터
    var title:String
    var originalTitle :String
    var releaseDate:String
    var video: Bool
    
    init(json:JSON){
        self.adult = json["adult"].boolValue
        self.backdropPath = json["backdrop_path"].stringValue
        self.id = json["id"].intValue
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

//{
//  "adult": false,
//  "backdrop_path": "/4HodYYKEIsGOdinkGi2Ucz6X9i0.jpg",
//  "id": 569094,
//  "title": "Spider-Man: Across the Spider-Verse",
//  "original_language": "en",
//  "original_title": "Spider-Man: Across the Spider-Verse",

//  "overview": "After reuniting with Gwen Stacy, Brooklyn’s full-time, friendly neighborhood Spider-Man is catapulted across the Multiverse, where he encounters the Spider Society, a team of Spider-People charged with protecting the Multiverse’s very existence. But when the heroes clash on how to handle a new threat, Miles finds himself pitted against the other Spiders and must set out on his own to save those he loves most.",
//  "poster_path": "/8Vt6mWEReuy4Of61Lnj5Xj704m8.jpg",

//  "media_type": "movie",
//  "genre_ids": [
//    16,
//    28,
//    12,
//    878
//  ],
//  "popularity": 3594.044,
//  "release_date": "2023-05-31",
//  "video": false,
//  "vote_average": 8.488,
//  "vote_count": 3008
//}
//--------------------------------------------

