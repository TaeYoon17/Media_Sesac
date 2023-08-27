//
//  SpokenLanguage.swift
//  assign
//
//  Created by 김태윤 on 2023/08/16.
//

import Foundation
struct SpokenLanguage: Codable {
    let englishName, iso639_1, name: String
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}
