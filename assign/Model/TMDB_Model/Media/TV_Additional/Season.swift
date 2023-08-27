//
//  Season.swift
//  assign
//
//  Created by 김태윤 on 2023/08/16.
//

import Foundation
struct Season: Codable {
    let airDate: String
    let episodeCount, seasonID: Int
    let seasonName, overview, posterPath: String
    let seasonNumber: Int
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case seasonID = "id", seasonName = "name", overview
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
        case voteAverage = "vote_average"
    }
}

struct SeasonDetail: Codable {
    let rawID:String
    let airDate: String
    let episodes: [EpisodeDetail]
    let seasonName, overview: String
    let seasonDetailID: Int
    let posterPath: String?
    let seasonNumber, voteAverage: Int

    enum CodingKeys: String, CodingKey {
        case rawID = "_id"
        case airDate = "air_date"
        case episodes, seasonName = "name", overview
        case seasonDetailID = "id"
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
        case voteAverage = "vote_average"
    }

    
}


