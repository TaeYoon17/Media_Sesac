//
//  AccountView.swift
//  assign
//
//  Created by 김태윤 on 2023/08/29.
//

import UIKit

final class AccountView: BaseView{
    let collectionView: UICollectionView = {
        let collectionView =  UICollectionView(frame: .zero, collectionViewLayout: AccountView.collectionViewLayout)
        return collectionView
    }()
    override func configureView() {
        self.addSubview(collectionView)
        self.backgroundColor = .white
    }
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    static private var collectionViewLayout:UICollectionViewLayout{
        let sectionProvider = { (sectionIndex:Int, layoutEnvorionment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = AccountVC.Section(rawValue: sectionIndex) else {return nil}
            let section: NSCollectionLayoutSection
            switch sectionKind{
            case .header:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.33))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,repeatingSubitem: item, count: 1)
                section = NSCollectionLayoutSection(group: group)
            case .footer,.main:
                var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                config.headerMode = .supplementary
                section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvorionment)
            }
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}
extension AccountView{
    class HeaderCell: UICollectionViewCell{
        var label = UILabel()
        var textField = UITextField()
        lazy var profileImageView = {
            let btn = UIButton()
            var config = UIButton.Configuration.plain()
            // uiimage 자체에 색상 설정하기
            let image = UIImage(systemName: "person.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            config.background.image = image
            config.background.image?.withTintColor(.darkGray)
            config.background.backgroundColor = .systemGray5
            config.background.imageContentMode = .scaleAspectFill
            btn.configuration = config
            return btn
        }()
        let avaterImageView = {
            let btn = UIButton()
            var config = UIButton.Configuration.plain()
            // uiimage 자체에 색상 설정하기
            let image = UIImage(systemName: "face.smiling")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            config.background.image = image
            config.background.image?.withTintColor(.darkGray)
            config.background.backgroundColor = .systemGray5
            config.background.imageContentMode = .scaleAspectFill
            btn.configuration = config
            return btn
        }()
        private let info = {
            let v = UIButton()
            var config = UIButton.Configuration.gray()
            config.baseBackgroundColor = .clear
            config.attributedTitle = .init("사진 또는 아바타 수정",attributes: .init([
                NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .subheadline)
            ]))
            config.contentInsets = .zero
            v.configuration = config
            return v
        }()
        private lazy var stView = {
            let stView = UIStackView(arrangedSubviews: [profileImageView,avaterImageView])
            stView.axis = .horizontal
            stView.distribution = .fillEqually
            stView.spacing = 16
            stView.alignment = .fill
            return stView
        }()
        override init(frame: CGRect) {
            super.init(frame: .zero)
            viewConfiguration()
            setConstraints()
//            backgroundColor = .cyan
        }
        required init?(coder: NSCoder) {
            fatalError("this cell is error")
        }
        private func viewConfiguration(){
            [stView,info].forEach{contentView.addSubview($0)}
        }
        func setConstraints(){
            stView.snp.makeConstraints { make in
                make.top.centerX.equalToSuperview()
                make.bottom.equalTo(info.snp.top).offset(-8)
//                make.bottom.equalToSuperview()
            }
            [profileImageView,avaterImageView].forEach{ v in
                v.snp.makeConstraints { make in
                    make.width.equalTo(v.snp.height)
                }
            }
            info.snp.makeConstraints { make in
                make.top.equalTo(stView.snp.bottom)
//                    .offset(8)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            info.setContentHuggingPriority(.init(253), for: .vertical)
//            info.setContentCompressionResistancePriority(.init(752), for: .vertical)
        }
        func dequeueCompletion(){
            DispatchQueue.main.async {
                self.profileImageView.configuration?.background.cornerRadius = self.profileImageView.frame.width / 2
                self.avaterImageView.configuration?.background.cornerRadius = self.avaterImageView.frame.width / 2
//                self.profileImageView.setNeedsLayout()
            }
        }
    }
}
