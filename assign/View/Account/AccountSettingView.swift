//
//  AccountVCSettingView.swift
//  assign
//
//  Created by 김태윤 on 2023/09/02.
//

import UIKit

final class AccountSettingView: BaseView{
    let collectionView = {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    override func configureView() {
        super.configureView()
        self.addSubview(collectionView)
    }
    override func setConstraints() {
        super.setConstraints()
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
