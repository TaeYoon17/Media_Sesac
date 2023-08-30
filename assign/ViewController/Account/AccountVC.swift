//
//  AccountVC.swift
//  assign
//
//  Created by 김태윤 on 2023/08/29.
//

import UIKit
class AccountVC:BaseVC{
    let mainView = AccountView()
    var diffableDataSource: UICollectionViewDiffableDataSource<Section,Item>?
    let footerInfo = [Item(keyInfo: "premiumIntroduce", label: "프로페셔널 계정으로 전환")
                      ,Item(keyInfo: "privacySettiing", label: "개인정보 설정")]
    let mainInfo = [
        Item(keyInfo: "name", label: "이름"),
        Item(keyInfo: "username", label: "사용자 이름"),
        Item(keyInfo: "sexNoun", label: "성별 대명사"),
        Item(keyInfo: "introduce", label: "소개"),
        Item(keyInfo: "link", label: "링크",placeholder: "링크 추가"),
        Item(keyInfo: "sex", label: "성별")
    ]
    let headerInfo = Item(keyInfo: "profile", label: "사진 또는 아바타 수정")
    override func loadView() {
        initNavigation()
        self.view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func configureView() {
        super.configureView()
        let sectionHeaderRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) {[weak self] headerView, elementKind, indexPath in
            let headerItem = self?.diffableDataSource?.snapshot().sectionIdentifiers[indexPath.section]
            var config = headerView.defaultContentConfiguration()
            config.text = headerItem?.description
            if headerItem != Section.header{
                headerView.contentConfiguration = config
            }
        }
        let headerRegistration = UICollectionView.CellRegistration<AccountView.HeaderCell,Item> { cell, indexPath, itemIdentifier in
            cell.label.text = itemIdentifier.label
            cell.textField.placeholder = itemIdentifier.placeholder
            cell.dequeueCompletion()
        }
        let mainRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,Item> { cell, indexPath, itemIdentifier in
            var defaultConfig = cell.defaultContentConfiguration()
            defaultConfig.text = itemIdentifier.label
            defaultConfig.prefersSideBySideTextAndSecondaryText = true
            cell.contentConfiguration = defaultConfig
            cell.accessories = [.label(text: itemIdentifier.placeholder ?? ""),.disclosureIndicator()]
        }
        let footerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,Item> { cell, indexPath, itemIdentifier in
            var defaultConfig = cell.defaultContentConfiguration()
            defaultConfig.attributedText = NSAttributedString(string: itemIdentifier.label,attributes: [
                NSAttributedString.Key.foregroundColor: itemIdentifier.keyInfo == "privacySettiing" ?  UIColor.tintColor : UIColor.label
            ])
            cell.contentConfiguration = defaultConfig
        }
        self.diffableDataSource = UICollectionViewDiffableDataSource<Section,Item>(collectionView: mainView.collectionView){ collectionView, indexPath, itemIdentifier in
            guard let section:AccountVC.Section = AccountVC.Section(rawValue: indexPath.section) else { fatalError("없는 섹션") }
            switch section{
            case .footer:
                let cell = collectionView.dequeueConfiguredReusableCell(using: footerRegistration, for: indexPath, item: itemIdentifier)
                return cell
            case .header:
                let cell = collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: itemIdentifier)
                return cell
            case .main:
                let cell = collectionView.dequeueConfiguredReusableCell(using: mainRegistration, for: indexPath, item: itemIdentifier)
                return cell
            }
        }
        self.diffableDataSource?.supplementaryViewProvider = { [weak self] collectionView,elementKind,indexPath -> UICollectionReusableView? in
            collectionView.dequeueConfiguredReusableSupplementary(using: sectionHeaderRegistration, for: indexPath)
        }
        self.diffableDataSource?.apply(initSnapshot())
    }
    override func setConstraints() {
        super.setConstraints()
    }
    func initSnapshot()->NSDiffableDataSourceSnapshot<Section,Item>{
        var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([headerInfo],toSection: .header)
        snapshot.appendItems(mainInfo,toSection: .main)
        snapshot.appendItems(footerInfo,toSection:.footer)
        return snapshot
    }
}
fileprivate extension AccountVC{
    func initNavigation(){
        self.navigationItem.title = "계정"
        self.navigationItem.rightBarButtonItem = .init(title: "완료", style: .done, target: self, action: #selector(Self.rightBtnTapped(_:)))
        self.navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .cancel, target: self, action: #selector(Self.leftBtnTapped(_:)))
    }
    @objc func rightBtnTapped(_ sender:UIBarButtonItem){
        print(#function)
        self.dismiss(animated: true)
    }
    @objc func leftBtnTapped(_ sender: UIBarButtonItem){
        print(#function)
        self.dismiss(animated: true)
    }
}
extension AccountVC{
    enum Section:Int, Hashable, CaseIterable{ // , CustomStringConvertible
        case header,main,footer
        var description:String{
            switch self{
            case .footer:return "추가 설정"
            case .main:return "사용자 정보"
            case .header:return "adf"
            }
        }
    }
    struct Item:Hashable{
        let keyInfo: String
        var label: String
        var placeholder: String?
        var input:String?
    }
}

