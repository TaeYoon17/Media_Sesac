//
//  SearchVC+CollectionView.swift
//  assign
//
//  Created by 김태윤 on 2023/08/21.
//

import UIKit
/// 각각의 상황에 맞는 다른 datasource를 갖게 만들고 이에 따라 적용시키는 방법으로 수정할 필요가 있다.
extension SearchVC{
    typealias SearchItem = SearchModel.SearchItem
    @MainActor
    func configureCollectionView(){
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: collectionView.topAnchor),
            view.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
        // 셀에 대한 초기 설정
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,SearchItem> { cell, indexPath, itemIdentifier in
            var config = cell.defaultContentConfiguration()
            config.text = itemIdentifier.called
            cell.contentConfiguration = config
        }
        // 각각의 셀에 맞는 데이터 초기 설정
        dataSource = UICollectionViewDiffableDataSource<ListType,SearchItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        /// 컬렉션 뷰 데이터 정보 구조를 이 데이터 정보 구조로 적용하기
        /// 추후에 상황에 맞는 datasource 변경하는 코드 적용할 필요 있음
        self.collectionView.dataSource = dataSource
    }
    @MainActor
    func queryPerform(text:String?){
        guard let searchModel else {return}
        var snapshot = NSDiffableDataSourceSnapshot<ListType,SearchItem>()
        snapshot.appendSections([.search])
        snapshot.appendItems(searchModel.queryItems(query: text))
        dataSource?.apply(snapshot,animatingDifferences: true)
    }
}
