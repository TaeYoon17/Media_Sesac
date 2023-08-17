//
//  MainItemCell.swift
//  assign
//
//  Created by 김태윤 on 2023/08/12.
//

import UIKit
import Kingfisher
class TrendItemCell: UITableViewCell {
    //Just View
    let baseImgURL = "https://image.tmdb.org/t/p/w300"
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var wrapperView: UIView!
    // 데이터 바인딩
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var posterImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clipBtn: UIButton!
    @IBOutlet weak var peoplesLabel: UILabel!
    @IBOutlet weak var ratingBtn: UIButton!
    static let identifier = String(describing: TrendItemCell.self)
    var media:(any Media)?{
        didSet{
            guard let media else {return}
            if let oldValue, media.mediaID == oldValue.mediaID{ return }
            if let genreId = media.genreIDS.first{
                genreLabel.text = "# \(media.mediaType.getGenre(id: genreId))"
            }
            titleLabel.text = media.called
            dateLabel.text = media.publishDate
            let genreTexts = media.genreIDS.map{media.mediaType.getGenre(id: $0)}.joined(separator: ", ")
            peoplesLabel.text = "All Genres: \(genreTexts)"
            let text = String(format: "%.2f", media.voteAverage)
            let rating = NSAttributedString(string: text,attributes: [.font: UIFont.systemFont(ofSize: 14)])
            ratingBtn.setAttributedTitle(rating, for: .normal)
            self.posterImgView.kf.setImage(with: URL(string: baseImgURL + (media.backdropPath ?? "")))
//            ratingBtn.setTitle(String(format: "%.2f", media.voteAverage), for: .normal)
        }
    }
    var clipBtnAction: UIAction?{
        didSet{
            if let oldValue{ clipBtn.removeAction(oldValue, for: .touchUpInside) }
            guard let clipBtnAction else {return}
            clipBtn.addAction(clipBtnAction, for: .touchUpInside)
        }
    }
    var peoples:String = ""{
        didSet{
            peoplesLabel.text = self.peoples
        }
    }
    var getGenreText: String = ""{
        didSet{
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUI()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    private func setUI(){
        self.selectionStyle = .none
        DispatchQueue.main.async { // setShadow
            self.clipsToBounds = false
            self.shadowView.clipsToBounds = false
            self.shadowView.layer.shadowRadius = 4
            self.shadowView.layer.shadowColor = UIColor.darkGray.cgColor
            self.shadowView.layer.shadowOffset = .zero
            self.shadowView.layer.shadowOpacity = 1
            self.wrapperView.clipsToBounds = true
            self.wrapperView.layer.cornerRadius = 16
        }
    }
}
