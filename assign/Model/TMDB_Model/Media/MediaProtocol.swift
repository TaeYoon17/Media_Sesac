//
//  Media.swift
//  assign
//
//  Created by 김태윤 on 2023/08/12.
//

import Foundation
protocol Media:Codable,Equatable{
    var adult:Bool {get set}
    var backdropPath :String? {get set}
    var mediaID:Int {get set}
    var overview:String {get set}
    var posterPath:String?{get set}
    var mediaType:TMDB.MediaType? {get set}
    var genreIDS:[Int] {get set}
    var popularity:Double {get set}
    var voteAverage:Double {get set}
    var voteCount:Int {get set}
    // 공통으로 갖지만 각자 다른 이름인 것
    var called:String {get}
    var originalCalled:String {get}
    var publishDate:String {get}
}
