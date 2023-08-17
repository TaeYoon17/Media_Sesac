//
//  URLExtensions.swift
//  assign
//
//  Created by 김태윤 on 2023/08/15.
//

import Foundation
extension URL{
    enum ImageType{
        case poster
        case info
        case collection
        case list
    }
    static func getImageURL(imgType: ImageType,path:String) -> URL?{
        let baseImgURL = "https://image.tmdb.org/t/p"
        switch imgType{
        case .info:
            return URL(string: baseImgURL + "/w500" + path)
        case .collection:
            return URL(string: baseImgURL + "/w300" + path)
        case .poster:
            return URL(string: baseImgURL + "w220_and_h330_face" + path)
        case .list:
            return URL(string: baseImgURL + "/w92" + path)
        }
    }
}
