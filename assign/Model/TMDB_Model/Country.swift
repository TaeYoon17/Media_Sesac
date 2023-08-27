//
//  Country.swift
//  assign
//
//  Created by 김태윤 on 2023/08/16.
//

import Foundation
struct Country: Codable {
    let iso3166_1, name: String
    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}
