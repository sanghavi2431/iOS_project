//
//  CategoryNewCell.swift
//  Woloo
//
//  Created by Kapil Dongre on 13/11/24.
//

import UIKit

class CategoryNewCell: UICollectionViewCell {

    @IBOutlet weak var vwBgImg: UIView!
    @IBOutlet weak var topicImageView: UIImageView!
    @IBOutlet weak var topicTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // self.vwBgImg.layer.cornerRadius = 30.0
       // self.topicImageView.layer.cornerRadius = 26.0
    }
    
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

    func setDataV2(_ info: CategoryModel) {
        topicTitleLabel.text = info.categoryName
        topicImageView.sd_setImage(with: URL(string: info.categoryIconURL ?? ""), completed: nil)
        
//        bgImageView.layer.cornerRadius = bgImageView.frame.size.height/2
    }
}

// MARK: - Cell's Handling
extension TrendingListCell {
    /// cell Related all operation do in this method
    /// - Parameters:
    ///   - cell: **CategoryCell**
    ///   - item: Index**IndexPath.item**
    private func fillCategoryCell(_ cell: CategoryCell,_ item: Int) {
        cell.topicTitleLabel.textColor = selectedCategories == item ? UIColor.backgroundColor : .gray
        if item == 0 {
            cell.topicImageView.image =  selectedCategories == item ?  #imageLiteral(resourceName: "checkMarkSquare") : #imageLiteral(resourceName: "checkMarkSquare").withTintColor(.gray)
            cell.topicTitleLabel.text = "All"
           // cell.bgImageView.isHidden = true
            //cell.selectedViewBoarder.isHidden = !(selectedCategories == item)
            return
        }
        if let info = listOfCategoryV2?[item - 1] {
            cell.setDataV2(info)
        }
        cell.bgImageView.isHidden = !(selectedCategories == item)
        //cell.selectedViewBoarder.isHidden = !(selectedCategories == item)
    }
}
