//
//  MainItemCell.swift
//  assign
//
//  Created by 김태윤 on 2023/08/12.
//

import UIKit

class MainItemCell: UITableViewCell {
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var posterImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clipBtn: UIButton!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var ratingBtn: UIButton!
    static let identifier = String(describing: MainItemCell.self)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        DispatchQueue.main.async {
            
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
