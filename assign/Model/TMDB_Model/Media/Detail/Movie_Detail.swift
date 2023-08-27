//
//  Movie_Detail.swift
//  assign
//
//  Created by 김태윤 on 2023/08/16.
//

import Foundation
// MARK: - Welcome
struct Movie_Detail: Codable {
    //MARK: -- 공통 부분
    let adult: Bool
    let backdropPath: String
    let productionCountries: [Country]
    let homepage: String
    let genres: [GenreModel]
    let voteAverage: Double
    let voteCount: Int
    let originalLanguage:String
    let spokenLanguages: [SpokenLanguage]
    let popularity: Double
    let posterPath: String
    let status, tagline:String
    let overview: String
    let productionCompanies: [Company]
    //MARK: -- 독자 부분
    let belongsToCollection: String?
    let budget: Int
    let movieDetailID: Int
    let imdbID, title, originalTitle:String
    let releaseDate: String
    let revenue, runtime: Int
    let video: Bool
    
    //MARK: -- Movie 부분

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage
        case movieDetailID = "id"
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}
