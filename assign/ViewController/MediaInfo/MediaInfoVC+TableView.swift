//
//  MediaInfoVC+Header.swift
//  assign
//
//  Created by 김태윤 on 2023/08/15.
//

import UIKit
import Kingfisher
extension MediaInfoVC: UITableViewDelegate,UITableViewDataSource{
    func configureTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setHeaderUI()
        self.bindingHeaderData()
        self.tableView.register(.init(nibName: CastInfoItemCell.identifier, bundle: nil),
                                forCellReuseIdentifier: CastInfoItemCell.identifier)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CastInfoItemCell.identifier) as? CastInfoItemCell else {return .init()}
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
84    }
}
//MARK: -- 테이블 뷰 헤더 설정하기
fileprivate extension MediaInfoVC{
    func setHeaderUI(){
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.init(white: 0, alpha: 0.6).cgColor]
        DispatchQueue.main.async {[weak self] in
            guard let self else {return}
            let halfHeight = headerView.bounds.height * 0.5
            gradient.frame = .init(x: 0, y: headerView.bounds.height - halfHeight, width: headerView.bounds.width, height: halfHeight)
//            imgBlurView.frame = headerView.frame
            headerView.layer.insertSublayer(gradient, at: 0)
            tableView.tableHeaderView = headerView
        }
        let prevBtnStatus: () -> Bool = {
            var isTapped = false
            let isTappedFn = {
                let prev = isTapped
                isTapped.toggle()
                return prev
            }
            return isTappedFn
        }()
         self.headerMoreBtn.addAction(.init(handler: {[weak self] _ in
             let prevStatus = prevBtnStatus()
             UIView.animate(withDuration: 0.3,animations: { [weak self] in
                 guard let self else {return}
                  if prevStatus{ // 이전 것이 true였다. 더보기 false와 관련 설정
                      headerMoreBtn.transform = CGAffineTransform(rotationAngle:  2 * .pi)
                      descriptionLabel.numberOfLines = 3
                      imgBlurView.alpha = 0
                      DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
                          self.imgBlurView.isHidden = prevStatus
                      }
                  }else{ // 이전 것이 false였다. 더보기 true와 관련 설정
                    descriptionLabel.numberOfLines = 0
                    headerMoreBtn.transform = CGAffineTransform(rotationAngle: .pi)
                    imgBlurView.alpha = 1
                    imgBlurView.isHidden = prevStatus
                  }
                 descriptionLabel.layoutIfNeeded()
             })
         }), for: .touchUpInside)
    }
    func bindingHeaderData(){
        let baseImgURL = "https://image.tmdb.org/t/p/w500"
        self.descriptionLabel.text = self.media?.overview
        self.calledLabel.text = self.media?.called
        self.backImgView.kf.setImage(with:  URL(string: baseImgURL + self.media!.posterPath))
    }
}
