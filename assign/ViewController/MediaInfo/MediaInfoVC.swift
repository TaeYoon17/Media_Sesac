//
//  MediaInfoVC.swift
//  assign
//
//  Created by 김태윤 on 2023/08/15.
//

import UIKit

class MediaInfoVC: UIViewController{
    enum PeopleType:Int,CaseIterable{ case cast,crew }
    //Model
    var media:(any Media)?
    var cast :[Credit]?
    var crew :[Credit]?
    //ViewController
    var loadCompletion:(()->Void)?
    @IBOutlet weak var popBtn: UIButton!
    //View
    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerMoreBtn: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var calledLabel: UILabel!
    @IBOutlet weak var imgBlurView: UIView!{
        didSet{
            imgBlurView.alpha = 0
            DispatchQueue.main.async {
                self.imgBlurView.getBlur(style: .systemMaterialDark,backgroundColor: .init(white: 0, alpha: 0.33))
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureaNaviagtion()
        self.configureTableView()
        print(media)
        loadCompletion?()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}


