//
//  NavigationControllerExtensions.swift
//  assign
//
//  Created by 김태윤 on 2023/08/29.
//

import UIKit
extension UINavigationController{
    /// WARNING: Change these constants according to your project's design
    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 40
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 16
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 12
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 6
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 32
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
    }
    @MainActor func insertAccount(){
        print(#function)
        guard self.navigationBar.prefersLargeTitles else {
            print("self.navigationBar.prefersLargeTitles \(self.navigationBar.prefersLargeTitles)")
            AppManager.shared.accountLogoView?.removeFromSuperview()
            return
        }
        AppManager.shared.accountLogoView?.removeFromSuperview()
        // 유저 계정 이미지가 있으면 그것을 가져오도록 코드를 수정해야함
        let imageView = UIImageView(image: AppManager.shared.accountImage ?? UIImage(systemName: "person.circle") )
        AppManager.shared.accountLogoView = imageView
        navigationBar.addSubview(imageView)
        // setup constraints
        imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(Self.goToAccount)))
    }
    @MainActor var accountHidden:Bool{
        get{ AppManager.shared.accountLogoView?.isHidden ?? false }
        set{ AppManager.shared.accountLogoView?.isHidden = newValue }
    }
    @MainActor var accountViewOpacity: Float{
        get{ AppManager.shared.accountLogoView?.layer.opacity ?? -1.0 }
        set{ AppManager.shared.accountLogoView?.layer.opacity = newValue }
    }
    //MARK: -- 나중에 다른 아이폰에도 적용 가능하게 만들어야함!! - 스크롤에 따라 어카운트 버튼 숨겨주기 기능
    @MainActor func scrollAccountView(nowY: CGFloat){
        let targetHeight:CGFloat = -103
        let normTarget:CGFloat = -143 + 103
        var norm = (nowY - targetHeight) / normTarget
        norm = max(0,norm,min(1,norm))
        self.accountViewOpacity = Float(norm)
        self.accountHidden = nowY > targetHeight
    }
    // 슈퍼뷰에서 없애주고 View를 비워줌
    @MainActor func deleteAccount(){
        AppManager.shared.accountLogoView?.removeFromSuperview()
        AppManager.shared.accountLogoView = nil
    }
    @objc func goToAccount(){
        let vc = AccountVC()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav,animated: true)
    }
}
