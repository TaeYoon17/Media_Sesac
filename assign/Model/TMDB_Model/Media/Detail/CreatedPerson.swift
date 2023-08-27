//
//  CreatedPerson.swift
//  assign
//
//  Created by 김태윤 on 2023/08/16.
//

import Foundation
struct CreatedPerson: Codable {
    let createdPersonID: Int
    let creditID, name: String
    let gender: Int
    let profilePath: String
    enum CodingKeys: String, CodingKey {
        case createdPersonID = "id"
        case creditID = "credit_id"
        case name, gender
        case profilePath = "profile_path"
    }
}
