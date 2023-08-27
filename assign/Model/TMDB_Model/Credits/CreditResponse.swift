//
//  CreditResponse.swift
//  assign
//
//  Created by 김태윤 on 2023/08/15.
//

import Foundation
// MARK: - CreditResponse
struct CreditResponse: Codable {
    let creditId: Int
    let cast, crew: [Credit]
    enum CodingKeys: String, CodingKey {
        case creditId = "id"
        case cast,crew
    }
}
