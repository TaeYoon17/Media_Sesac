//
//  Episode.swift
//  assign
//
//  Created by 김태윤 on 2023/08/16.
//

import Foundation
struct Episode: Codable {
    let episodeID: Int
    let name, overview: String
    let voteAverage, voteCount: Int
    let airDate: String
    let episodeNumber: Int
    let episodeType, productionCode: String
    let runtime, seasonNumber, showID: Int
    let stillPath: String

    enum CodingKeys: String, CodingKey {
        case episodeID = "id", name, overview
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case episodeType = "episode_type"
        case productionCode = "production_code"
        case runtime
        case seasonNumber = "season_number"
        case showID = "show_id"
        case stillPath = "still_path"
    }
}


struct EpisodeDetail: Codable {
    enum EpisodeType: String, Codable {
        case finale = "finale"
        case standard = "standard"
    }
    let airDate: String
    let episodeNumber: Int
    let crew, guestStars: [Person]
    let name, overview, productionCode: String
    let id: Int
    let stillPath: String?
    let voteAverage, voteCount: Int
    let runtime: Int?
    let seasonNumber:Int
    
    let episodeType: EpisodeType?
    let showID: Int?
    
    
    
    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case episodeType = "episode_type"
        case id, name, overview
        case productionCode = "production_code"
        case runtime
        case seasonNumber = "season_number"
        case showID = "show_id"
        case stillPath = "still_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case crew
        case guestStars = "guest_stars"
    }
}
