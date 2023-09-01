//
//  AccountVC.swift
//  assign
//
//  Created by 김태윤 on 2023/08/29.
//

import UIKit
import Photos
import PhotosUI
import CoreImage
import Combine
class AccountVC:BaseVC{
    let mainView = AccountView()
    @Published var profileImage = AppManager.shared.accountImage
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
    lazy var photoPicker = {[weak self] in
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.navigationController?.delegate = self
        picker.delegate = self
        return picker
    }()
    let infoAlert:UIAlertController = {
        let alert = UIAlertController(title: "어떤 것을 가져올래?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: "프로필 사진", style: .default))
        alert.addAction(.init(title: "아바타", style: .default))
        alert.addAction(.init(title: "취소", style: .cancel))
        return alert
    }()
    var subscription = Set<AnyCancellable>()
    override func loadView() {
        initNavigation()
        self.view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.collectionView.delegate = self
    }
    deinit{ print("accountVC deinit!!") }
    override func configureView() {
        super.configureView()
        configureDataSource()
    }
    override func setConstraints() {
        super.setConstraints()
    }
    
}
extension AccountVC{
    func configureDataSource(){
        let sectionHeaderRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) {[weak self] headerView, elementKind, indexPath in
            let headerItem = self?.diffableDataSource?.snapshot().sectionIdentifiers[indexPath.section]
            var config = headerView.defaultContentConfiguration()
            config.text = headerItem?.description
            if headerItem != Section.header{ headerView.contentConfiguration = config }
        }
        let mainRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,Item> {cell, indexPath, itemIdentifier in
            var defaultConfig = cell.defaultContentConfiguration()
            defaultConfig.text = itemIdentifier.label
            defaultConfig.prefersSideBySideTextAndSecondaryText = true
            var backConfig = UIBackgroundConfiguration.listPlainCell()
            cell.backgroundConfiguration = backConfig
            cell.contentConfiguration = defaultConfig
            cell.accessories = [.label(text: itemIdentifier.placeholder ?? ""),.disclosureIndicator()]
        }
        let headerRegistration = UICollectionView.CellRegistration<AccountView.HeaderCell,Item> {[weak self] cell, indexPath, itemIdentifier in
//            guard let self else {return}
            cell.dequeueCompletion()
        }
        
        let footerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,Item> {cell, indexPath, itemIdentifier in
            var defaultConfig = cell.defaultContentConfiguration()
            defaultConfig.attributedText = NSAttributedString(string: itemIdentifier.label,attributes: [
                NSAttributedString.Key.foregroundColor: itemIdentifier.keyInfo == "privacySettiing" ?
                UIColor.tintColor : UIColor.label
            ])
            cell.contentConfiguration = defaultConfig
        }
        self.diffableDataSource = UICollectionViewDiffableDataSource<Section,Item>(collectionView: mainView.collectionView){[weak self] c, indexPath, item in
            guard let self else {fatalError("weak self error \(#function)")}
            guard let section:AccountVC.Section = AccountVC.Section(rawValue: indexPath.section) else { fatalError("없는 섹션") }
            // 여기 반복을 어떻게 줄일까...
            switch section{
            case .footer:
                return c.dequeueConfiguredReusableCell(using: footerRegistration, for: indexPath, item: item)
            case .header:
                let cell = c.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
                self.$profileImage.sink { image in cell.profileImageView.configuration?.background.image = image }
                    .store(in: &self.subscription)
                cell.profileImageView.addAction(.init(handler: {[weak self] _ in self?.present(self!.photoPicker,animated: true) }),
                                                for: .touchUpInside)
                cell.info.addAction(.init(handler: {[weak self] _ in
                    self?.present(self!.infoAlert,animated: true) }), for: .touchUpInside)
                return cell
            case .main:
                return c.dequeueConfiguredReusableCell(using: mainRegistration, for: indexPath, item: item)
            }
        }
        self.diffableDataSource?.supplementaryViewProvider = { collectionView,elementKind,indexPath -> UICollectionReusableView? in
            collectionView.dequeueConfiguredReusableSupplementary(using: sectionHeaderRegistration, for: indexPath)
        }
        self.diffableDataSource?.apply({
            var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
            snapshot.appendSections(Section.allCases)
            zip(Section.allCases, [[headerInfo],mainInfo,footerInfo])
                .forEach { snapshot.appendItems($1,toSection: $0) }
            return snapshot
        }())
    }
}
extension AccountVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SettingVC()
        // 터치 후 Select 색상 남기지 않기
        collectionView.deselectItem(at: indexPath, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
