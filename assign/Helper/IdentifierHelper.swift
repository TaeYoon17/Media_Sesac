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
protocol ConvertableJSON{
    var id:Int {get set}
    init(json:JSON)
}
