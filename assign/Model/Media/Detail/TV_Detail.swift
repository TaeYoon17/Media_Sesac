//
//  TV_Detail.swift
//  assign
//
//  Created by 김태윤 on 2023/08/16.
//

import Foundation
import SwiftyJSON
// MARK: - Welcome
struct TVDetail: Codable {
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
    let status, tagline, type: String
    let overview: String
    let productionCompanies: [Company]
    //MARK: -- 독자 부분
    let createdBy: [CreatedPerson]
    let episodeRunTime: [Int]
    let inProduction: Bool
    let languages: [String]
    let lastAirDate: String
    let firstAirDate: String
    let originCountry: [String]
    let name,originalName:String
    let tvDetailID: Int
    let seasons: [Season]
    let networks: [Company]
    let lastEpisodeToAir: Episode
    let nextEpisodeToAir: Episode
    let numberOfEpisodes, numberOfSeasons: Int

    enum CodingKeys: String, CodingKey {
        
        case adult
        case backdropPath = "backdrop_path"
        case createdBy = "created_by"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case genres, homepage
        case tvDetailID = "id"
        case inProduction = "in_production"
        case languages
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
        case name
        case nextEpisodeToAir = "next_episode_to_air"
        case networks
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case seasons
        case spokenLanguages = "spoken_languages"
        case status, tagline, type
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
