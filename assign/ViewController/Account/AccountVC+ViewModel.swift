//
//  AccountVC+ViewData.swift
//  assign
//
//  Created by 김태윤 on 2023/08/31.
//

import Foundation
extension AccountVC{
    enum Section:Int, Hashable, CaseIterable{ // , CustomStringConvertible
        case header,main,footer
        var description:String{
            switch self{
            case .footer:return "추가 설정"
            case .main:return "사용자 정보"
            case .header:return "adf"
            }
        }
    }
    struct Item:Hashable,Identifiable{
        internal var id:String{ keyInfo }
        let keyInfo: String
        var label: String
        var placeholder: String?
        var input:String?
    }
    enum AccountType:String{
        case name,username,sexNoun,introduce,link,sex
    }
}
