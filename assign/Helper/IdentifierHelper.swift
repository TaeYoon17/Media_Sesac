//
//  IdentifierHelper.swift
//  assign
//
//  Created by 김태윤 on 2023/08/11.
//

import Foundation
import SwiftyJSON
protocol ReusableProtocol{
    static var identifier:String{get}
}
extension ReusableProtocol{
    static var identifier:String{
        String(describing: self)
    }
}
extension MediaInfoVC: ReusableProtocol{}
extension TrendVC: ReusableProtocol{}
extension CollectionViewWrapperCell:ReusableProtocol{}
extension RecommendItemCell:ReusableProtocol{}
