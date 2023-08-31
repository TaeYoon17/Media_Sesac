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
    var subscription = Set<AnyCancellable>()
    override func loadView() {
        initNavigation()
        self.view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    deinit{
        print("accountVC deinit!!")
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
        let headerRegistration = UICollectionView.CellRegistration<AccountView.HeaderCell,Item> {[weak self] cell, indexPath, itemIdentifier in
            guard let self else {return}
            self.$profileImage.sink { image in
                cell.profileImageView.configuration?.background.image = image
            }.store(in: &self.subscription)
            cell.profileImageView.addAction(.init(handler: {[weak self] _ in
                self?.present(self!.photoPicker,animated: true)
            }), for: .touchUpInside)
            cell.info.addAction(.init(handler: {[weak self] _ in
                let alert = UIAlertController(title: "어떤 것을 가져올래?", message: nil, preferredStyle: .actionSheet)
                alert.addAction(.init(title: "프로필 사진", style: .default))
                alert.addAction(.init(title: "아바타", style: .default))
                alert.addAction(.init(title: "취소", style: .cancel))
                self?.present(alert,animated: true)
            }), for: .touchUpInside)
            cell.dequeueCompletion()
        }
        let mainRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,Item> {cell, indexPath, itemIdentifier in
            var defaultConfig = cell.defaultContentConfiguration()
            defaultConfig.text = itemIdentifier.label
            defaultConfig.prefersSideBySideTextAndSecondaryText = true
            cell.contentConfiguration = defaultConfig
            cell.accessories = [.label(text: itemIdentifier.placeholder ?? ""),.disclosureIndicator()]
        }
        let footerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,Item> {cell, indexPath, itemIdentifier in
            var defaultConfig = cell.defaultContentConfiguration()
            defaultConfig.attributedText = NSAttributedString(string: itemIdentifier.label,attributes: [
                NSAttributedString.Key.foregroundColor: itemIdentifier.keyInfo == "privacySettiing" ?
                UIColor.tintColor : UIColor.label
            ])
            cell.contentConfiguration = defaultConfig
        }
        self.diffableDataSource = UICollectionViewDiffableDataSource<Section,Item>(collectionView: mainView.collectionView){collectionView, indexPath, itemIdentifier in
            guard let section:AccountVC.Section = AccountVC.Section(rawValue: indexPath.section) else { fatalError("없는 섹션") }
            switch section{
            case .footer:
                return collectionView.dequeueConfiguredReusableCell(using: footerRegistration, for: indexPath, item: itemIdentifier)
            case .header:
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: itemIdentifier)
            case .main:
                return collectionView.dequeueConfiguredReusableCell(using: mainRegistration, for: indexPath, item: itemIdentifier)
            }
        }
        self.diffableDataSource?.supplementaryViewProvider = {collectionView,elementKind,indexPath -> UICollectionReusableView? in
            collectionView.dequeueConfiguredReusableSupplementary(using: sectionHeaderRegistration, for: indexPath)
        }
        self.diffableDataSource?.apply(initSnapshot)
    }
    override func setConstraints() {
        super.setConstraints()
    }
    var initSnapshot:NSDiffableDataSourceSnapshot<Section,Item>{
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
        AppManager.shared.accountImage = profileImage
        self.dismiss(animated: true)
    }
    @objc func leftBtnTapped(_ sender: UIBarButtonItem){
        self.dismiss(animated: true)
    }
}


extension AccountVC: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        if let result = results.first{
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                DispatchQueue.main.async {
                    self.profileImage = image
                    // TODO: - Here you get UIImage
                }
            }
        }
    }
}
extension AccountVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        picker.dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
//        info[UIImagePickerController.InfoKey.originalImage]
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            DispatchQueue.main.async {[weak self] in
                self?.profileImage = image
                // TODO: - Here you get UIImage
            }
            dismiss(animated: true)
        }
    }
}
