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
        case Trend(media:TMDB.MediaType,date:TMDB.Time_Window),Credit
        var endPoint:String{
            switch self{
            case .Credit: return ""
            case let .Trend(media,date):
                return "/trending/\(media.rawValue)/\(date.rawValue)?language=en-US"
            }
        }
        var method: HTTPMethod{
            switch self{
            case .Credit:return .get
            case .Trend: return .get
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
            case .Credit: return nil
            case .Trend:
                return nil
            }
        }
        
        func action(successCompletion:@escaping (JSON) -> Void
                    ,failHandler: ((AFError) ->Void)? = nil){
            AF.request(Self.baseURL + endPoint,method: method, parameters: params,headers: headers)
                .validate(statusCode: 200...300)
                .responseJSON{ val in
                    switch val.result{
                    case .success(let data):
                        let json = JSON(data)
//                        print(json)
                        successCompletion(json)
                    case .failure(let err):
//                        print(err)
                        guard let failHandler else {return}
                        failHandler(err)
                    }
                }
        }
    }
}
