//
//  AccountInputCell.swift
//  assign
//
//  Created by 김태윤 on 2023/09/02.
//

import UIKit
import SnapKit
import Combine

fileprivate struct CustomContentConfiguration: UIContentConfiguration, Hashable {
    static func == (lhs: CustomContentConfiguration, rhs: CustomContentConfiguration) -> Bool {
        lhs.text == rhs.text
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }
    
    var image: UIImage? = nil
    var tintColor: UIColor? = nil // 여기를 선택 컬러로 바꾸기..?
    var text: String? = nil
    var userText:String? = nil
    
    weak var textFieldDelegate: UITextFieldDelegate?
    func makeContentView() -> UIView & UIContentView {
        print(#function)
        let customContentView =  CustomContentView(configuration: self,textField: textFieldDelegate)
//        customContentView.textField.publisher(for: \.text).sink { str in
//            print(str)
//        }.store(in: &self.subscription)
        return customContentView
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

final class CustomContentView: UIView, UIContentView {
    fileprivate init(configuration: CustomContentConfiguration,textField Delegate: UITextFieldDelegate?) {
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
    fileprivate let textField = UITextField()
    weak var textFieldDelegate: UITextFieldDelegate?{
        didSet{
            guard let textFieldDelegate else {return}
            textField.delegate = textFieldDelegate
        }
    }
    private func setupInternalViews() {
        textField.placeholder = "필수사항"
        textField.delegate = textFieldDelegate
        addSubview(labelText)
        addSubview(textField)
        textField.backgroundColor = .lightGray
//        imageView.isHidden = true
        // 셀의 너비의 유동 폭을 지정한다. 슈퍼뷰 0.2 <= 라벨 뷰 너비 <= 슈퍼뷰 0.25
        labelText.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(layoutMarginsGuide).inset(16)
            make.width.greaterThanOrEqualTo(self).multipliedBy(0.2)
            make.width.lessThanOrEqualTo(self).multipliedBy(0.25)
        }
        labelText.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        labelText.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.snp.makeConstraints { make in
            make.verticalEdges.equalTo(layoutMarginsGuide)
            make.leadingMargin.equalTo(labelText.snp.trailing).offset(8)
            make.trailingMargin.equalTo(layoutMarginsGuide).inset(20)
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

class CustomConfigurationCell: UICollectionViewListCell {
    var key: String?
    var labelText: String?{
        didSet{ setNeedsUpdateConfiguration() }
    }
    var placeholder: String? = ""{
        didSet{ setNeedsUpdateConfiguration() }
    }
    var userTextPassthrough = PassthroughSubject<(String,String),Never>()
    deinit{
        print("CustomConfigurationCell은 잘 해제됨!!")
    }
    override func updateConfiguration(using state: UICellConfigurationState) {
        self.backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        var content = CustomContentConfiguration().updated(for: state)
        content.text = labelText
        content.textFieldDelegate = self
        self.contentConfiguration = content
        guard let customView = self.contentView as? CustomContentView else {
            print("없어용~~")
            return
        }
        customView.textFieldDelegate = self
    }
}
extension CustomConfigurationCell: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        userTextPassthrough.send((key!,textField.text!))
    }
//    func textFieldDidChangeSelection(_ textField: UITextField) {
//        print(#function)
//        print(textField.text)
//    }
}


//MARK: -- 필요없는 Configuration
//fileprivate struct CustomBackgroundConfiguration {
//    static func configuration(for state: UICellConfigurationState) -> UIBackgroundConfiguration {
//        var background = UIBackgroundConfiguration.clear()
//        let backConfig = UIBackgroundConfiguration.listGroupedCell()
//
//        return backConfig
//        background.cornerRadius = 10
//        if state.isHighlighted || state.isSelected {
//            // Set nil to use the inherited tint color of the cell when highlighted or selected
//            background.backgroundColor = .lightGray
//
//            if state.isHighlighted {
//                // Reduce the alpha of the tint color to 30% when highlighted
//                background.backgroundColorTransformer = .init { $0.withAlphaComponent(0.3) }
//            }
//        }
//        return background
//    }
//}
