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
        self.tableView.sectionHeaderTopPadding = 0 // 섹션 헤더 패딩 없애기
        self.setHeaderUI()
        self.bindingHeaderData()
        self.tableView.register(.init(nibName: CastInfoItemCell.identifier, bundle: nil),
                                forCellReuseIdentifier: CastInfoItemCell.identifier)
        self.tableView.register(.init(nibName: CollectionViewWrapperCell.identifier, bundle: nil), forCellReuseIdentifier: CollectionViewWrapperCell.identifier)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        SectionType.allCases.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        guard let type = PeopleType(rawValue: section) else {return nil}
//        switch type{
//        case .cast: return "연기자"
//        case .crew: return "제작진"
//        }
        guard let type = SectionType(rawValue: section) else {return nil}
        switch type{
        case .cast: return "연기자"
        case .crew: return "제작진"
        case .recommend: return "추천작"
        }
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView()
//        view.backgroundColor = .white
//        let label = UILabel(frame: .init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
//        label.textColor = .black
//        label.text = "연기자"
//        view.addSubview(label)
//        return view
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = SectionType(rawValue: indexPath.section) else {return .init()}
        switch type{
        case .cast,.crew:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CastInfoItemCell.identifier) as? CastInfoItemCell else {return .init()}
            cell.credit =  type == .cast ? self.cast?[indexPath.row] : self.crew?[indexPath.row]
            return cell
        case .recommend:
            guard let c = tableView.dequeueReusableCell(withIdentifier: CollectionViewWrapperCell.identifier) as? CollectionViewWrapperCell else {return .init()}
            c.recommendList = self.recommendMedia
            return c
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let type = SectionType(rawValue: section) else {return 0}
        switch type{
        case .cast: return cast?.count ?? 0
        case .crew: return crew?.count ?? 0
        case .recommend: return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let type = SectionType(rawValue: indexPath.section) else {return 0}
        switch type{
        case .cast,.crew: return 84
        case .recommend: return self.tableView.bounds.width / 2.5
        }
    }
}
//MARK: -- 테이블 뷰 헤더 설정하기
fileprivate extension MediaInfoVC{
    @MainActor
    func setHeaderUI(){
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.init(white: 0, alpha: 0.6).cgColor]
        tableView.tableHeaderView = headerView
        DispatchQueue.main.async {[weak self] in
            guard let self else {return}
            let ySuper = self.headerView.convert(headerView.bounds.origin, to: self.view).y
            let myHeight = backImgView.bounds.height - ySuper
            let halfHeight = myHeight * 0.5
            headerView.frame = .init(x: 0, y: 0, width: backImgView.bounds.width, height: myHeight)
            imgBlurView.frame = backImgView.frame
            gradient.frame = .init(x: 0, y: myHeight - halfHeight, width: headerView.bounds.width, height: halfHeight)
            headerView.layer.insertSublayer(gradient, at: 0)
            self.tableView.reloadData()
        }
        var nowBtnStatus = false
        self.headerMoreBtn.addAction(.init(handler: {[weak self] _ in
             UIView.animate(withDuration: 0.3,animations: { [weak self] in
                 guard let self else {return}
                  if !nowBtnStatus{ // 이전 것이 true였다. 더보기 false와 관련 설정
                      headerMoreBtn.transform = CGAffineTransform(rotationAngle:  2 * .pi)
                      descriptionLabel.numberOfLines = 3
                      imgBlurView.alpha = 0
                      DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
                          self.imgBlurView.isHidden = !nowBtnStatus
                      }
                  }else{ // 이전 것이 false였다. 더보기 true와 관련 설정
                    descriptionLabel.numberOfLines = 0
                    headerMoreBtn.transform = CGAffineTransform(rotationAngle: .pi)
                    imgBlurView.alpha = 1
                    imgBlurView.isHidden = !nowBtnStatus
                  }
                 nowBtnStatus.toggle()
                 descriptionLabel.layoutIfNeeded()
             })
         }), for: .touchUpInside)
    }
    func bindingHeaderData(){
        let baseImgURL = "https://image.tmdb.org/t/p/w500"
        self.descriptionLabel.text = self.media?.overview
        self.calledLabel.text = self.media?.called
        if let backPath = self.media?.posterPath, let url = URL(string: baseImgURL + backPath){
            self.backImgView.kf.setImage(with: url)
        }else{
            self.backImgView.image = UIImage(named: "picture_demo")
        }
    }
}
