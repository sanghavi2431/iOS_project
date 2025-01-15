//
//  AddReviewDescriptionCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 11/11/24.
//

import UIKit

class AddReviewDescriptionCell: UITableViewCell {

    @IBOutlet weak var txtVw: UITextView!
    @IBOutlet weak var vwBack: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.vwBack.layer.borderWidth = 1.0
        self.vwBack.layer.cornerRadius = 10.0
        self.vwBack.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
