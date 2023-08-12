//
//  MainItemCell.swift
//  assign
//
//  Created by 김태윤 on 2023/08/12.
//

import UIKit

class MainItemCell: UITableViewCell {
    static let identifier = String(describing: MainItemCell.self)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
