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
    static let shared = AppManager()
    private override init(){
        super.init()
    }
}
