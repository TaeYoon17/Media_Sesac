//
//  SearchVC.swift
//  assign
//
//  Created by 김태윤 on 2023/08/21.
//

import UIKit
import Combine
class SearchVC: UIViewController{
    enum ListType{
        case main, search
    }
    enum ViewType{
        case main, searching
    }
    let searchModel = SearchModel()
    var viewType:ViewType = .main{
        didSet{
            switch viewType{
            case .main:
                break
//                self.collectionView.dataSource =
            case .searching:
                break
//                self.collectionView.dataSource = UICollectionViewDiffableDataSource<ListType,SearchModel.SearchItem>{
//
//                }
            }
        }
    }
    let searchController = UISearchController(searchResultsController: nil)
    var dataSource:UICollectionViewDiffableDataSource<ListType,SearchModel.SearchItem>?
    lazy var collectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureCollectionView()
    }
}
//MARK: -- UISearchController 설정하기
extension SearchVC:UISearchResultsUpdating,UISearchBarDelegate{
    func configureSearchController(){
        searchController.searchBar.placeholder = "미디어 검색"
        searchController.searchBar.scopeButtonTitles = TMDB.MediaType.allCases.map{$0.rawValue.uppercased()}
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = self.searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard !(searchController.searchBar.text?.isEmpty ?? true) else {
            queryPerform(text: nil)
            return
        }
        queryPerform(text: searchController.searchBar.text)
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchController.searchBar.showsScopeBar = true
//        self.dataSourceType = .search
        return true
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchController.searchBar.showsScopeBar = false
        DispatchQueue.main.async {
            self.queryPerform(text: "")
        }
        return true
    }
}
