//
//  IdentifierHelper.swift
//  assign
//
//  Created by 김태윤 on 2023/08/11.
//

import Foundation
import SwiftyJSON
protocol Identifier{
    static var identifier:String{get}
}

extension MediaInfoVC: Identifier{
    static var identifier: String{
        String(describing: MediaInfoVC.self)
    }
}

extension TrendVC: Identifier{
    static var identifier: String{
        String(describing: TrendVC.self)
    }
}
