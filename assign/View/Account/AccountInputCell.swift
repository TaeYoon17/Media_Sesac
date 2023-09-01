//
//  AccountInputCell.swift
//  assign
//
//  Created by 김태윤 on 2023/09/02.
//

import UIKit
import SnapKit
fileprivate struct CustomBackgroundConfiguration {
    static func configuration(for state: UICellConfigurationState) -> UIBackgroundConfiguration {
        var background = UIBackgroundConfiguration.clear()
        background.cornerRadius = 10
        if state.isHighlighted || state.isSelected {
            // Set nil to use the inherited tint color of the cell when highlighted or selected
            background.backgroundColor = nil
            
            if state.isHighlighted {
                // Reduce the alpha of the tint color to 30% when highlighted
                background.backgroundColorTransformer = .init { $0.withAlphaComponent(0.3) }
            }
        }
        return background
    }
}

fileprivate struct CustomContentConfiguration: UIContentConfiguration, Hashable {
    var image: UIImage? = nil
    var tintColor: UIColor? = nil // 여기를 선택 컬러로 바꾸기..?
    var text: String? = nil
    func makeContentView() -> UIView & UIContentView {
        return CustomContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        guard let state = state as? UICellConfigurationState else { return self }
        var updatedConfig = self
        if state.isSelected || state.isHighlighted {
            updatedConfig.tintColor = .white
        }
        return updatedConfig
    }
}

class CustomContentView: UIView, UIContentView {
    fileprivate init(configuration: CustomContentConfiguration) {
        super.init(frame: .zero)
        setupInternalViews()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfig = newValue as? CustomContentConfiguration else { return }
            apply(configuration: newConfig)
        }
    }
    
    private let imageView = UIImageView()
    //MARK: -- 여기에 뷰에 표시하고 싶은 뷰들 설정
    private let labelText = UILabel()
    private let textField = UITextField()
    private func setupInternalViews() {
        
        addSubview(labelText)
        addSubview(textField)
        
//        NSLayoutConstraint.activate([
//            imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
//            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
//            imageView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
//        ])
//        imageView.preferredSymbolConfiguration = .init(font: .preferredFont(forTextStyle: .body), scale: .large)
//        imageView.isHidden = true
        labelText.snp.makeConstraints { make in
            make.verticalEdges.equalTo(layoutMarginsGuide)
            make.centerY.equalTo(layoutMarginsGuide)
            make.height.equalTo(50)
        }
    }
    
    private var appliedConfiguration: CustomContentConfiguration!
    
    private func apply(configuration: CustomContentConfiguration) {
        
        guard appliedConfiguration != configuration else { return } // 이전에 적용한 Custom Configuration과 같다면 return 한다.
        appliedConfiguration = configuration
        imageView.isHidden = configuration.image == nil
        imageView.image = configuration.image
        imageView.tintColor = configuration.tintColor
        labelText.text = configuration.text
        labelText.font = .preferredFont(forTextStyle: .body)
        labelText.textColor = .black
    }
}

class CustomConfigurationCell: UICollectionViewCell {
    var image: UIImage? {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    var text: String?{
        didSet{
            print("변화를 부름!!")
            setNeedsUpdateConfiguration()
        }
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        self.backgroundConfiguration = CustomBackgroundConfiguration.configuration(for: state)
        
        var content = CustomContentConfiguration().updated(for: state)
        content.image = image
        content.text = text
        self.contentConfiguration = content
    }
}
