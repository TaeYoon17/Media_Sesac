//
//  AccountSeetingVC.swift
//  assign
//
//  Created by 김태윤 on 2023/09/02.
//

import UIKit
extension AccountVC{
    class SettingVC: BaseVC{
        enum Section{case main}
        struct Item:Hashable,Identifiable{
            let id = UUID()
            var key:String
            var field:String?
        }
        private var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
        private let mainView = AccountSettingView()
        override func loadView() {
            self.view = mainView
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.title = "Custom Configurations"
        }
        override func configureView() {
            super.configureView()
            configureDataSource()
        }
        override func setConstraints() {
            super.setConstraints()
        }
        
        func configureDataSource(){
            let cellRegistration = UICollectionView.CellRegistration<CustomConfigurationCell,Item>{ cell, indexPath, item in
                cell.text = item.key
            }
            dataSource = UICollectionViewDiffableDataSource<Section,Item>(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
                collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            })
            
            dataSource.apply({
                var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
                snapshot.appendSections([.main])
                snapshot.appendItems([Item(key: "이름"),Item(key: "성별")])
                return snapshot
            }())
        }
    }
}
