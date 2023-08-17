//
//  MediaInfoVC.swift
//  assign
//
//  Created by 김태윤 on 2023/08/15.
//

import UIKit

class MediaInfoVC: UIViewController{
    enum PeopleType:Int,CaseIterable{ case cast,crew }
    enum SectionType:Int,CaseIterable{
        case recommend
        case cast
        case crew
    }
    //Model
    var media:(any Media)?{
        didSet{
            guard let media else {return}
            TMDB.Router.Recommend(media: media.mediaType, id: media.mediaID, page: 1).action { [weak self] (response:MediaResponse) in
                self?.recommendMedia = response.results
            }
        }
    }
    var cast :[Credit]?
    var crew :[Credit]?
    var recommendMedia :[any Media]?{
        didSet{
            guard let recommendMedia,let tableView else { return }
            tableView.reloadSections(IndexSet(SectionType.recommend.rawValue..<SectionType.cast.rawValue), with: .automatic)
        }
    }
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
        loadCompletion?()
        tableView.reloadSections(IndexSet(SectionType.recommend.rawValue..<SectionType.cast.rawValue), with: .automatic)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}


