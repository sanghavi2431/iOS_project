//
//  AddReviewStarCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 09/11/24.
//

import UIKit

class AddReviewStarCell: UITableViewCell {

    @IBOutlet weak var vwBackStar: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.vwBackStar.layer.borderWidth = 1.0
        self.vwBackStar.layer.borderColor = UIColor.lightGray.cgColor
        self.vwBackStar.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
