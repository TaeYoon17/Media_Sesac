//
//  Credits.swift
//  assign
//
//  Created by 김태윤 on 2023/08/15.
//

import Foundation


// MARK: - Cast
struct Credit: Codable {
    let adult: Bool
    let gender, personID: Int
    let knownForDepartment: TMDB.Department
    let name, originalName: String
    let popularity: Double
    let profilePath: String?
    let castID: Int?
    let character: String?
    let creditID: String
    let order: Int?
    let department: TMDB.Department?
    let job: String?
    enum CodingKeys: String, CodingKey {
        case adult, gender
        case personID = "id"
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
}


