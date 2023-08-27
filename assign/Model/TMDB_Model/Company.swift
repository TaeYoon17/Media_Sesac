//
//  Company.swift
//  assign
//
//  Created by 김태윤 on 2023/08/16.
//

import Foundation
struct Company: Codable {
    let companyID: Int
    let logoPath, name, originCountry: String

    enum CodingKeys: String, CodingKey {
        case companyID = "id"
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}
