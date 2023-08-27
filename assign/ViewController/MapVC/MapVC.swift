//
//  Mapvc.swift
//  assign
//
//  Created by 김태윤 on 2023/08/27.
//

import UIKit
import SnapKit
class MapVC: UIViewController{
    @DefaultsState(\.isNotFirst) var isNotFirst
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = .init(title: "돌아가기", style: .plain, target: self, action: #selector(Self.returnTapped(_:)))
    }
    @objc func returnTapped(_ sender: UIBarButtonItem){
        isNotFirst.toggle()
    }
}
