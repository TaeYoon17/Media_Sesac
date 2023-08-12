//
//  MovieResponse.swift
//  assign
//
//  Created by 김태윤 on 2023/08/12.
//

import Foundation
import SwiftyJSON
struct TrendResponse{
    let page:Int
    let results: [Media]
    let totalPages:Int
    let totalResults:Int
    init(json:JSON){
        self.page = json["page"].intValue
        self.totalPages = json["total_pages"].intValue
        self.totalResults = json["total_results"].intValue
        self.results = json["results"].arrayValue.map{ element in
            let elementType = TMDB.MediaType(rawValue: element["media_type"].stringValue) ?? .all
            switch elementType{
            case .all: fatalError("타입 변환에 문제")
            case .movie: return Movie(json: element)
            case .tv: return TV(json: element)
            }
        }
    }
}
protocol List{}
struct MovieList:List{
    var list:[Movie]
}
