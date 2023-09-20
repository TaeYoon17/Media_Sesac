//
//  Person.swift
//  assign
//
//  Created by 김태윤 on 2023/08/15.
//

import Foundation
struct Person: Codable {
    let adult: Bool
    let id: Int
    let name, originalName, mediaType: String
    let popularity: Double
    let gender: Int
    let knownForDepartment: String
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case adult, id, name
        case originalName = "original_name"
        case mediaType = "media_type"
        case popularity, gender
        case knownForDepartment = "known_for_department"
        case profilePath = "profile_path"
    }
}
