//
//  AccountSeetingVC.swift
//  assign
//
//  Created by 김태윤 on 2023/09/02.
//

import UIKit
import Combine
extension AccountVC{
    final class SettingVC: BaseVC{
        enum Section{
            case main
        }
        struct Item:Hashable{
            let key:String
            var field:String?
        }
        let originItems = [Item(key: "성"),Item(key: "이름")].reduce(into: [:]) { $0[$1.key] = $1 }
        lazy var items = originItems{
            didSet{
                if items.contains(where: { $1.field == nil || $1.field == ""}) {
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                }else{
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                }
            }
        }
        var completion: ((AccountVC.Item) -> Void)?
        private var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
        private let mainView = AccountSettingView()
        var subscription = Set<AnyCancellable>()
        override func loadView() {
            self.view = mainView
        }
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        override func configureView() {
            super.configureView()
            configureNavigation()
            configureDataSource()
        }
        override func setConstraints() {
            super.setConstraints()
        }
        
        func configureDataSource(){
            let cellRegistration = UICollectionView.CellRegistration<CustomConfigurationCell,Item>{ cell, indexPath, item in
                cell.labelText = item.key
                cell.key = item.key
            }
            mainView.collectionView.register(CustomConfigurationCell.self, forCellWithReuseIdentifier: String(describing: CustomConfigurationCell.self))
            dataSource = UICollectionViewDiffableDataSource<Section,Item>(collectionView: mainView.collectionView, cellProvider: {[weak self] collectionView, indexPath, itemIdentifier in
                guard let self else {fatalError("이게 왜 사라지지?")}
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
                cell.userTextPassthrough.sink {[weak self] key, value in
                    print(key,value)
                    self?.items[key]?.field = value
                }.store(in: &subscription)
                return cell
            })
            
            dataSource.apply({
                var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
                snapshot.appendSections([.main])
                snapshot.appendItems(items.map{$1})
                return snapshot
            }())
        }
        func configureNavigation(){
            self.navigationItem.title = "이름"
            self.navigationItem.rightBarButtonItem = .init(title: "완료", style: .plain, target: self, action: #selector(Self.completTapped(_:)))
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        @objc func completTapped(_ sender: UIBarButtonItem){
            guard let 성 = self.items["성"]?.field, let 이름 = self.items["이름"]?.field else {return}
            let placeholder = "\(성)\(이름)"
            AppManager.shared.userName = "\(성)\(이름)"
            completion?(AccountVC.Item(keyInfo: "name", label: "이름",placeholder: placeholder))
            self.navigationController?.popViewController(animated: true)
        }
    }
}
/// 셀 타입
/// 1. 텍스트 필드가 존재하는 셀
/// 2. 
            
