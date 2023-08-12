//
//  RouterProtocol.swift
//  assign
//
//  Created by 김태윤 on 2023/08/11.
//

import Foundation
import Alamofire
protocol RouterProtocol{
    static var baseURL:String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var params: Parameters? { get }
}
