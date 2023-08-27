//
//  RecommendItemCell.swift
//  assign
//
//  Created by 김태윤 on 2023/08/17.
//

import UIKit

class RecommendItemCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImgView.layer.cornerRadius = 8
    }
}
