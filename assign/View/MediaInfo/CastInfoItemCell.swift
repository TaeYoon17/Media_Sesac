//
//  CastInfoItemCell.swift
//  assign
//
//  Created by 김태윤 on 2023/08/15.
//

import UIKit

class CastInfoItemCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var positionNameLabel: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    static let identifier = String(describing: CastInfoItemCell.self)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImgView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
