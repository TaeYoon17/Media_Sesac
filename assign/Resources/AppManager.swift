//
//  AppManager.swift
//  assign
//
//  Created by 김태윤 on 2023/08/29.
//

import Foundation
import Combine
import UIKit
final class AppManager: NSObject{
    var accountLogoView: UIImageView?
//    @DefaultsState(\.)
    @DefaultsState(\.profileImage) var accountImage {
        didSet{
            accountLogoView?.image = accountImage
        }
    }
    var userName: String?
//    var accountImage: UIImage? = UIImage(named: "SwiftUI"){
//        didSet{
//            accountLogoView?.image = accountImage
//        }
//    }
    static let shared = AppManager()
    private override init(){
        super.init()
    }
}
