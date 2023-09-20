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
    var credit : Credit?{
        didSet{
            guard let credit else {return}
            self.titleLabel.text = credit.name
            self.positionNameLabel.text = credit.character
            DispatchQueue.global().async {
//                self.profileImgView.image = Data
                guard let profile = credit.profilePath, let url = URL.getImageURL(imgType: .list, path: profile),let data = try? Data(contentsOf: url) else {return}
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.profileImgView.image = image
                }
            }
        }
    }
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
