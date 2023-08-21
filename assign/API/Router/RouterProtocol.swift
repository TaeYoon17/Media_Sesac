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
    var endPoint: String {get}
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var params: Parameters? { get }
    func action<T:Codable>(queue: DispatchQueue,successCompletion:@escaping (T) -> Void,failHandler: (() ->Void)?)
    
}
extension RouterProtocol{
    func action<T:Codable>(queue: DispatchQueue,successCompletion:@escaping (T) -> Void,failHandler: (() ->Void)?){
        let afRequest = AF.request(Self.baseURL + endPoint,method: method, parameters: params,headers: headers)
        afRequest.responseDecodable(of: T.self,queue: .global()){ response in
                queue.async {
                    guard let value = response.value else {
                        print(response.description)
                        failHandler?()
                        return
                    }
                    successCompletion(value)
                }
            }
    }
}
