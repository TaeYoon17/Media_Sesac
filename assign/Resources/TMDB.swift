//
//  TMDB.swift
//  assign
//
//  Created by 김태윤 on 2023/08/11.
//

import Foundation
enum TMDB{
    enum MediaType:String,Codable{
        case all, movie, tv
    }
    enum Time_Window:String{
        case day,week
    }
    enum LanguageCode: String{
        case en,kr,ja
    }
    enum Gender:Int{
        case not, male,female,non_binary
    }
}
