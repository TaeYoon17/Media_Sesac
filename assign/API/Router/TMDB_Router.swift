//
//  TMDB.swift
//  assign
//
//  Created by 김태윤 on 2023/08/11.
//

import Foundation
import Alamofire
import SwiftyJSON
extension TMDB{
    enum Router:RouterProtocol{
        static var baseURL: String{ "https://api.themoviedb.org/3"}
        case Trend(media:TMDB.MediaType,date:TMDB.Time_Window)
        case Credit(media:TMDB.MediaType,id:Int)
        var endPoint:String{
            switch self{
            case let .Credit(media,id):
                return "/\(media.rawValue)/\(id)/credits?language=en-US"
            case let .Trend(media,date):
                return "/trending/\(media.rawValue)/\(date.rawValue)?language=en-US"
            }
        }
        var method: HTTPMethod{
            switch self{
            case .Credit,.Trend:return .get
            }
        }
        var headers: HTTPHeaders{
            var headers = HTTPHeaders()
            switch self{
            case .Credit,.Trend:
                headers["Authorization"] = "Bearer \(API_Key.TMDB_ACCESS_TOKEN)"
                return headers
            }
        }
        var params: Parameters?{
            switch self{
            case .Credit,.Trend: return nil
            }
        }
        
        func action<T:Codable>(successCompletion:@escaping (T) -> Void
                               ,failHandler: (() ->Void)? = nil){
            let afRequest = AF.request(Self.baseURL + endPoint,method: method, parameters: params,headers: headers)
            afRequest.responseDecodable(of: T.self){ response in
                guard let value = response.value else {
                    if let failHandler{ failHandler()}
                    return
                }
                successCompletion(value)
            }
            //MARK: -- Legacy SwiftyJSON
            //                afRequest
            //                    .validate(statusCode: 200...300)
            //                    .responseJSON{ val in
            //                        switch val.result{
            //                        case .success(let data):
            //                            let json = JSON(data)
            //                            successCompletion(json)
            //                        case .failure(let err):
            //                            guard let failHandler else {return}
            //                            failHandler(err)
            //                        }
            //                    }
            
        }
    }
}
