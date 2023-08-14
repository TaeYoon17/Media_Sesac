//
//  DateExtensions.swift
//  assign
//
//  Created by 김태윤 on 2023/08/14.
//

import Foundation
extension Date{
    static var dayFormatString:String{get{ "yyyy년 M월 dd일" }}
    var day:String{
        let formatter = DateFormatter()
        formatter.dateFormat = Self.dayFormatString
        return formatter.string(from: self)
    }
    var getWeek:String?{
        let calendar = Calendar.current
        let weekKorean = [ "첫","둘","셋","넷","다섯" ]
        let components = calendar.dateComponents([.weekOfMonth,.month,.year], from: self)
        guard let weekOfMonth = components.weekOfMonth, let month = components.month,let year = components.year else {return nil}
        return "\(year)년 \(month)월 \(weekKorean[weekOfMonth - 1])째주"
    }
}
