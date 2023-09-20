//
//  GenreModel.swift
//  assign
//
//  Created by 김태윤 on 2023/08/16.
//

import Foundation
struct GenreModel: Codable {
    let id: Int
    let name: String
    enum CodingKeys: String, CodingKey {
        case id,name
    }
}
